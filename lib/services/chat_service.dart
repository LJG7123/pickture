import '../models/chat_room.dart';
import '../repositories/chat_repository.dart';
import '../core/error/app_exception.dart';

class ChatService {
  final ChatRepository _repository;
  
  // 메모리 캐시
  final Map<String, ChatRoom> _cache = {};

  ChatService({ChatRepository? repository}) 
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
      // 비즈니스 로직: 중복 채팅방 생성 방지
      if (participants.isEmpty) {
        throw AppException(
          '참여자가 없습니다.',
          code: 'empty_participants',
        );
      }
      
      if (participants.length != participants.toSet().length) {
        throw AppException(
          '중복된 참여자가 있습니다.',
          code: 'duplicate_participants',
        );
      }

      return _repository.createChatRoom(participants);
    } catch (e) {
      if (e is AppException) rethrow;
      
      throw AppException(
        '채팅방 생성에 실패했습니다.',
        code: 'create_chat_room_failed',
        details: e.toString(),
      );
    }
  }
} 