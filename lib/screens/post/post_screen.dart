import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/providers/post_provider.dart';
import 'package:pickture/screens/post/widgets/post_card/post_card.dart';

class PostScreen extends ConsumerWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postProvider);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          final post = posts[index];
          return PostCard(post: post);
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Post"),
      centerTitle: true,
      actions: [
        Row(
          children: [
            IconButton(
              onPressed: () => context.push("/save", extra: null),
              icon: const Icon(Icons.add),
            ),
            IconButton(
              onPressed: () => context.push('/chats'),
              icon: const Icon(Icons.messenger_outline),
            ),
          ],
        )
      ],
    );
  }
}
