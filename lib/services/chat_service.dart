import '../models/chat_room.dart';
import '../repositories/chat_repository.dart';
import '../core/error/app_exception.dart';
import '../models/message.dart';
import '../services/user_service.dart';
import '../core/cache/cache_manager.dart';

class ChatService {
  final ChatRepository _repository;
  final UserService _userService;
  final CacheManager<ChatRoom> _cache;

  ChatService({
    ChatRepository? repository,
    UserService? userService,
    Duration? cacheTTL,
  })  : _repository = repository ?? ChatRepository(),
        _userService = userService ?? UserService(),
        _cache = CacheManager<ChatRoom>(defaultTTL: cacheTTL ?? const Duration(minutes: 30));

  Stream<List<ChatRoom>> getChatRooms(String userId) {
    try {
      final stream = _repository.getChatRoomsStream(userId);
      return stream.map((chatRooms) {
        _updateCache(chatRooms);
        return _sortByLastMessage(chatRooms);
      });
    } catch (e) {
      throw AppException(
        '채팅방 목록을 불러오는데 실패했습니다.',
        code: 'get_chat_rooms_failed',
        details: e.toString(),
      );
    }
  }

  void _updateCache(List<ChatRoom> chatRooms) {
    for (final chatRoom in chatRooms) {
      _cache.set(chatRoom.id, chatRoom);
    }
  }

  List<ChatRoom> _sortByLastMessage(List<ChatRoom> chatRooms) {
    chatRooms.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    return chatRooms;
  }

  Future<ChatRoom> getChatRoom(String chatId) async {
    try {
      final cachedRoom = _cache.get(chatId);
      if (cachedRoom != null) {
        return cachedRoom;
      }

      final chatRoom = await _repository.getChatRoom(chatId);
      _cache.set(chatRoom.id, chatRoom);

      // 그룹채팅인 경우 참가자 정보 프리로드
      if (chatRoom.isGroupChat) {
        await _userService.getUsersByIds(chatRoom.participants);
      }

      return chatRoom;
    } catch (e) {
      throw AppException(
        '채팅방을 불러오는데 실패했습니다.',
        code: 'get_chat_room_failed',
        details: e.toString(),
      );
    }
  }

  Future<ChatRoom> createChatRoom(List<String> participants, {String? groupName}) async {
    try {
      // 1:1 채팅인 경우 기존 채팅방 확인
      if (participants.length == 2) {
        final existingChatRoom = await _repository.findChatRoomByParticipants(participants);
        if (existingChatRoom != null) {
          final chatRoom = ChatRoom.fromFirestore(existingChatRoom);
          _cache.set(chatRoom.id, chatRoom);
          return chatRoom;
        }
      }

      // 새 채팅방 생성
      final chatRoom = await _repository.createChatRoom(participants, groupName: groupName);
      _cache.set(chatRoom.id, chatRoom);

      // 참가자 정보 프리로드
      await _userService.getUsersByIds(participants);

      return chatRoom;
    } catch (e) {
      throw AppException(
        '채팅방 생성에 실패했습니다.',
        code: 'create_chat_room_failed',
        details: e.toString(),
      );
    }
  }

  Future<void> sendMessage(String chatId, String content, String senderId) async {
    try {
      if (content.trim().isEmpty) {
        throw AppException(
          '메시지 내용을 입력해주세요',
          code: 'empty_message',
        );
      }

      await _repository.sendMessage(chatId, content, senderId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException(
        '메시지 전송에 실패했습니다.',
        code: 'send_message_failed',
        details: e.toString(),
      );
    }
  }

  Stream<List<Message>> getMessages(String chatId) {
    try {
      return _repository.getMessagesStream(chatId);
    } catch (e) {
      throw AppException(
        '메시지를 불러오는데 실패했습니다.',
        code: 'get_messages_failed',
        details: e.toString(),
      );
    }
  }

  // 주기적으로 만료된 캐시 정리
  void cleanExpiredCache() {
    _cache.removeExpired();
  }
}
