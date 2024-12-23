import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_room.dart';
import '../models/user_model.dart';
import '../models/message.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ChatRoom>> getChatRoomsStream(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ChatRoom.fromFirestore(doc)).toList());
  }

  Future<ChatRoom> createChatRoom(List<String> participants) async {
    final docRef = await _firestore.collection('chats').add({
      'participants': participants,
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadCount': 0,
    });

    final doc = await docRef.get();
    return ChatRoom.fromFirestore(doc);
  }

  Future<ChatRoom> getChatRoom(String chatId) async {
    final doc = await _firestore.collection('chats').doc(chatId).get();
    return ChatRoom.fromFirestore(doc);
  }

  Future<DocumentSnapshot?> findChatRoomByParticipants(
      List<String> participants) async {
    final querySnapshot = await _firestore
        .collection('chats')
        .where('participants', arrayContainsAny: participants)
        .get();

    // 정확히 해당 참여자들로만 구성된 채팅방 찾기
    final matchingDoc = querySnapshot.docs.where(
      (doc) {
        final docParticipants = List<String>.from(doc['participants']);
        return docParticipants.length == participants.length &&
            docParticipants.every((p) => participants.contains(p));
      },
    );
    return matchingDoc.isEmpty ? null : matchingDoc.first;
  }

  Future<UserModel?> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) return null;
    return UserModel.fromJson(doc.id, doc.data()!);
  }

  Future<void> sendMessage(
      String chatId, String content, String senderId) async {
    final message = Message(
      id: '', // Firestore will generate this
      senderId: senderId,
      content: content,
      sentTime: DateTime.now(),
      type: MessageType.text,
      isRead: false,
      readBy: {},
      isDeleted: false,
    );

    final messageData = message.toFirestore();

    // 메시지 추가
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);

    // 채팅방 정보 업데이트
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': content,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadCount': FieldValue.increment(1),
    });
  }

  Stream<List<Message>> getMessagesStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('sentTime', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList();
    });
  }
}
