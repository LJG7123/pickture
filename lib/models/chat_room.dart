import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String id;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final String? groupName;
  final String? groupImage;

  ChatRoom({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    this.groupName,
    this.groupImage,
  });

  factory ChatRoom.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatRoom(
      id: doc.id,
      participants: List<String>.from(data['participants'] ?? []),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: data['lastMessageTime'] != null
          ? (data['lastMessageTime'] as Timestamp).toDate()
          : DateTime.now(),
      unreadCount: data['unreadCount'] ?? 0,
      groupName: data['name'],
      groupImage: data['image'],
    );
  }
}
