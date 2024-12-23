import '../models/chat_room.dart';
import '../repositories/chat_repository.dart';
import '../core/error/app_exception.dart';
import '../models/message.dart';
import '../services/user_service.dart';

class ChatService {
  final ChatRepository _repository;

  // 메모리 캐시
  final Map<String, ChatRoom> _cache = {};

  ChatService({ChatRepository? repository, UserService? userService})
      : _repository = repository ?? ChatRepository();

  Stream<List<ChatRoom>> getChatRooms(String userId) {
    return _repository.getChatRoomsStream(userId).map((chatRooms) {
      // 캐시 업데이트
      for (final chatRoom in chatRooms) {
        _cache[chatRoom.id] = chatRoom;
      }

      // 비즈니스 로직: 최근 메시지 순으로 정렬
      chatRooms.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

      return chatRooms;
    });
  }

  Future<ChatRoom> getChatRoom(String chatId) async {
    try {
      // 캐시 확인
      if (_cache.containsKey(chatId)) {
        return _cache[chatId]!;
      }

      final chatRoom = await _repository.getChatRoom(chatId);
      _cache[chatId] = chatRoom;
      return chatRoom;
    } catch (e) {
      throw AppException(
        '채팅방을 찾을 수 없습니다.',
        code: 'chat_room_not_found',
        details: e.toString(),
      );
    }
  }

  Future<ChatRoom> createChatRoom(List<String> participants) async {
    try {
      // 이미 존재하는 채팅방 확인
      final existingChatRoom =
          await _repository.findChatRoomByParticipants(participants);
      if (existingChatRoom != null) {
        return ChatRoom.fromFirestore(existingChatRoom);
      }

      // 새 채팅방 생성
      final chatRoom = await _repository.createChatRoom(participants);
      _cache[chatRoom.id] = chatRoom;
      return chatRoom;
    } catch (e) {
      throw AppException(
        '채팅방 생성에 실패했습니다.',
        code: 'create_chat_room_failed',
        details: e.toString(),
      );
    }
  }

  Future<ChatRoom> createChatRoomWithUser(
      String currentUserId, String otherUserId) async {
    if (currentUserId.isEmpty) {
      throw AppException(
        '로그인이 필요합니다',
        code: 'auth_required',
      );
    }

    return await createChatRoom([currentUserId, otherUserId]);
  }

  Future<String> startChatWithUser(
      String? currentUserId, String otherUserId) async {
    if (currentUserId == null || currentUserId.isEmpty) {
      throw AppException(
        '로그인이 필요합니다',
        code: 'auth_required',
      );
    }

    final chatRoom = await createChatRoomWithUser(currentUserId, otherUserId);
    return chatRoom.id;
  }

  Future<void> sendMessage(
      String chatId, String content, String senderId) async {
    if (content.trim().isEmpty) {
      throw AppException(
        '메시지 내용을 입력해주세요',
        code: 'empty_message',
      );
    }

    if (senderId.isEmpty) {
      throw AppException(
        '로그인이 필요합니다',
        code: 'auth_required',
      );
    }

    try {
      await _repository.sendMessage(chatId, content, senderId);
    } catch (e) {
      throw AppException(
        '메시지 전송에 실패했습니다.',
        code: 'send_message_failed',
        details: e.toString(),
      );
    }
  }

  Stream<List<Message>> getMessages(String chatId) {
    return _repository.getMessagesStream(chatId);
  }
}
