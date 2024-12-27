import 'package:flutter/material.dart';
import '../../../../models/message.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message.content,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
