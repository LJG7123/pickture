import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/chat_room.dart';
import '../models/message.dart';
import '../models/user_model.dart';
import '../services/chat_service.dart';
import '../providers/user_provider.dart';
import '../core/error/app_exception.dart';

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
  if (chatId.isEmpty) throw AppException('채팅방 ID가 없습니다.');
  return ref.read(chatServiceProvider).getChatRoom(chatId);
}

@riverpod
Stream<List<Message>> messages(Ref ref, String chatId) {
  return ref.read(chatServiceProvider).getMessages(chatId);
}

@riverpod
Future<ChatRoom> createChatRoom(
  Ref ref,
  ({List<String> participants, String? groupName}) params,
) async {
  return ref.read(chatServiceProvider).createChatRoom(
        params.participants,
        groupName: params.groupName,
      );
}

@riverpod
Future<UserModel?> chatRoomUser(Ref ref, ChatRoom chatRoom) async {
  if (chatRoom.isGroupChat) return null;

  final participants = chatRoom.participants;
  if (participants.length != 2) return null;

  final users = await ref.read(usersByIdsProvider(participants).future);
  return users.firstOrNull;
}

@riverpod
class MessageUserIds extends _$MessageUserIds {
  @override
  Set<String> build() => {};

  void updateMessageUserIds(List<Message> messages) {
    final userIds = messages.where((m) => m.senderId.isNotEmpty).map((m) => m.senderId).toSet();
    state = userIds;
    ref.read(usersByIdsProvider(userIds.toList()));
  }

  @override
  bool updateShouldNotify(Set<String> previous, Set<String> next) {
    return previous.length != next.length || previous.any((id) => !next.contains(id));
  }
}

@riverpod
Future<void> sendMessage(
  Ref ref,
  ({String chatId, String content, String senderId}) params,
) async {
  if (params.content.trim().isEmpty) {
    throw AppException('메시지를 입력해주세요.');
  }

  await ref.read(chatServiceProvider).sendMessage(
        params.chatId,
        params.content.trim(),
        params.senderId,
      );
}

@riverpod
Future<({ChatRoom chatRoom, UserModel? otherUser})> chatRoomWithUser(
  Ref ref,
  String chatId,
) async {
  final chatRoom = await ref.watch(chatRoomProvider(chatId).future);

  if (chatRoom.participants.length > 2) {
    return (chatRoom: chatRoom, otherUser: null);
  }

  final otherUser = await ref.watch(chatRoomUserProvider(chatRoom).future);
  return (chatRoom: chatRoom, otherUser: otherUser);
}
