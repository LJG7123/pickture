import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/chat_room.dart';
import '../models/message.dart';
import '../models/user_model.dart';
import '../services/chat_service.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';

part 'gen/chat_provider.g.dart';

@riverpod
ChatService chatService(Ref ref) {
  return ChatService();
}

@riverpod
Stream<List<ChatRoom>> chatRooms(Ref ref, String userId) {
  return ref.read(chatServiceProvider).getChatRooms(userId);
}

@riverpod
Future<ChatRoom> chatRoom(Ref ref, String chatId) async {
  return ref.read(chatServiceProvider).getChatRoom(chatId);
}

@riverpod
Stream<List<Message>> messages(Ref ref, String chatId) {
  return ref.read(chatServiceProvider).getMessages(chatId);
}

@riverpod
Future<String> createChatRoom(
    Ref ref, ({List<String> participants, String? groupName}) params) async {
  final chatRoom = await ref
      .read(chatServiceProvider)
      .createChatRoom(params.participants, groupName: params.groupName);
  return chatRoom.id;
}

@riverpod
Future<String> startChatWithUser(Ref ref, String otherUserId) async {
  final currentUserId = ref.read(authProvider).value?.uid;
  return await ref
      .read(chatServiceProvider)
      .startChatWithUser(currentUserId, otherUserId);
}

@riverpod
Future<UserModel?> chatRoomUser(Ref ref, ChatRoom chatRoom) async {
  final currentUserId = ref.read(authProvider).value?.uid;
  final otherUserId =
      chatRoom.participants.firstWhere((id) => id != currentUserId);
  return ref.read(userProvider(otherUserId).future);
}
