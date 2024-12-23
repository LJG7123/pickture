import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/models/post.dart';
import 'package:pickture/providers/auth_provider.dart';
import 'package:pickture/providers/post_provider.dart';

class SaveDialog extends ConsumerWidget {
  const SaveDialog({
    super.key,
    this.post,
  });

  final Post? post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController(text: post?.title);
    final contentController = TextEditingController(text: post?.content);

    return AlertDialog(
      title: Text(post == null ? "Add Post" : "Edit Post"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: "Title"),
          ),
          TextField(
            controller: contentController,
            decoration: const InputDecoration(labelText: "Content"),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final savePost = createPost(
                post, titleController.text, contentController.text, ref);
            if (post == null) {
              ref.read(postProvider.notifier).addPost(savePost);
            } else {
              ref.read(postProvider.notifier).updatePost(savePost);
            }
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Calcel"),
        ),
      ],
    );
  }
}

Post createPost(Post? post, String title, String content, WidgetRef ref) {
  return Post(
    postId: post?.postId ?? "",
    title: title,
    content: content,
    likes: post?.likes ?? [],
    comments: post?.comments ?? [],
    createUserModel: post?.createUserModel ?? ref.watch(authProvider).value!,
    createdAt: post?.createdAt ?? DateTime.now(),
    updatedAt: post == null ? null : DateTime.now(),
  );
}
