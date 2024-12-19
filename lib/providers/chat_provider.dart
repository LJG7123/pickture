import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_room.dart';
import '../services/chat_service.dart';
import '../repositories/chat_repository.dart';
import 'auth_provider.dart';

part 'chat_provider.g.dart';

@riverpod
ChatService chatService(Ref ref) {
  return ChatService(repository: ChatRepository());
}

@riverpod
Stream<List<ChatRoom>> chatRooms(Ref ref) {
  final service = ref.watch(chatServiceProvider);
  final user = ref.watch(authProvider);

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
