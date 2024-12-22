import 'package:pickture/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../models/chat_room.dart';
import '../models/message.dart';
import '../services/chat_service.dart';
import '../repositories/chat_repository.dart';
import 'auth_provider.dart';

part 'gen/chat_provider.g.dart';

@riverpod
ChatService chatService(Ref ref) {
  return ChatService(repository: ChatRepository());
}

@riverpod
Stream<List<ChatRoom>> chatRooms(Ref ref) {
  final service = ref.watch(chatServiceProvider);
  final user = ref.watch(authProvider).value;

  if (user == null) {
    return Stream.value([]);
  }

  return service.getChatRooms(user.uid);
}

@riverpod
Future<ChatRoom> chatRoom(Ref ref, String chatId) {
  final service = ref.watch(chatServiceProvider);
  return service.getChatRoom(chatId);
}

@riverpod
Future<UserModel?> chatRoomUser(Ref ref, ChatRoom chatRoom) async {
  final currentUser = ref.watch(authProvider).value;
  if (currentUser == null) return null;

  final otherUserId = chatRoom.participants
      .firstWhere((id) => id != currentUser.uid, orElse: () => '');

  if (otherUserId.isEmpty) return null;

  final service = ref.watch(chatServiceProvider);
  return service.getUser(otherUserId);
}

@Riverpod(keepAlive: true)
Stream<List<Message>> messages(Ref ref, String chatId) {
  final service = ref.watch(chatServiceProvider);
  return service.getMessages(chatId);
}

@riverpod
class ChatRoomController extends _$ChatRoomController {
  @override
  Future<UserModel?> build(String chatId) async {
    return _loadOtherUser(chatId);
  }

  Future<UserModel?> _loadOtherUser(String chatId) async {
    final chatService = ref.read(chatServiceProvider);
    final currentUser = ref.read(authProvider).value;
    if (currentUser == null) return null;

    final chatRoom = await chatService.getChatRoom(chatId);
    final otherUserId = chatRoom.participants.firstWhere(
      (id) => id != currentUser.uid,
      orElse: () => '',
    );

    if (otherUserId.isEmpty) return null;
    return await chatService.getUser(otherUserId);
  }

  Future<void> sendMessage(String chatId, String message) async {
    final currentUser = ref.read(authProvider).value;
    await ref.read(chatServiceProvider).sendMessage(
          chatId,
          message,
          currentUser?.uid ?? '',
        );
  }

  Future<void> sendMessageAndClear(
      String chatId, String message, TextEditingController controller) async {
    if (message.trim().isEmpty) return;

    await sendMessage(chatId, message).then((_) {
      controller.clear();
    });
  }

  Future<String> startChatWithUser(UserModel contact) async {
    final currentUser = ref.read(authProvider).value;
    return ref.read(chatServiceProvider).startChatWithUser(
          currentUser?.uid,
          contact.uid,
        );
  }
}
