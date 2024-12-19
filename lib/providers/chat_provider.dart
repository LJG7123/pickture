import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/chat_room.dart';
import '../services/chat_service.dart';
import '../repositories/chat_repository.dart';

part 'chat_provider.g.dart';

@riverpod
ChatService chatService(ChatServiceRef ref) {
  return ChatService(repository: ChatRepository());
}

@riverpod
Stream<List<ChatRoom>> chatRooms(ChatRoomsRef ref) {
  final service = ref.watch(chatServiceProvider);
  // TODO: userId는 실제 로그인된 사용자 ID로 대체 필요
  const userId = 'current_user_id';
  return service.getChatRooms(userId);
}

@riverpod
Future<ChatRoom> chatRoom(ChatRoomRef ref, String chatId) {
  final service = ref.watch(chatServiceProvider);
  return service.getChatRoom(chatId);
} 