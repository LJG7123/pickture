import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_room.dart';

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
}
