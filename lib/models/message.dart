import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  text,
  image,
  video,
  voice,
  deleted
}

class Message {
  final String id;
  final String senderId;
  final String content;
  final DateTime sentTime;
  final MessageType type;
  final bool isRead;
  final Map<String, DateTime>? readBy;
  final bool isDeleted;

  Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.sentTime,
    required this.type,
    this.isRead = false,
    this.readBy,
    this.isDeleted = false,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    // readBy 맵 변환
    Map<String, DateTime>? readByMap;
    if (data['readBy'] != null) {
      readByMap = Map<String, DateTime>.from(
        (data['readBy'] as Map).map(
          (key, value) => MapEntry(
            key as String,
            (value as Timestamp).toDate(),
          ),
        ),
      );
    }

    return Message(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      content: data['content'] ?? '',
      sentTime: (data['sentTime'] as Timestamp).toDate(),
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${data['type'] ?? 'text'}',
        orElse: () => MessageType.text,
      ),
      isRead: data['isRead'] ?? false,
      readBy: readByMap,
      isDeleted: data['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'content': content,
      'sentTime': Timestamp.fromDate(sentTime),
      'type': type.toString().split('.').last,
      'isRead': isRead,
      'readBy': readBy?.map(
        (key, value) => MapEntry(key, Timestamp.fromDate(value)),
      ),
      'isDeleted': isDeleted,
    };
  }

  Message copyWith({
    String? id,
    String? senderId,
    String? content,
    DateTime? sentTime,
    MessageType? type,
    bool? isRead,
    Map<String, DateTime>? readBy,
    bool? isDeleted,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      sentTime: sentTime ?? this.sentTime,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      readBy: readBy ?? this.readBy,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
} 