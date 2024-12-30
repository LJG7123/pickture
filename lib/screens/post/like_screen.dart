import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/models/like.dart';

class LikeScreen extends ConsumerWidget {
  const LikeScreen({super.key, required this.likes});

  final List<Like> likes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Like"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: likes.length,
        itemBuilder: (BuildContext context, int index) {
          final like = likes[index];

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: const CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 20,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(like.user!.userId),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
            onTap: () {},
          );
        },
      ),
    );
  }
}
