import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/models/post.dart';
import 'package:pickture/providers/auth_provider.dart';
import 'package:pickture/providers/post_provider.dart';
import 'package:pickture/providers/file_provider.dart';
import 'package:pickture/screens/post/save_screen.dart';

class PostHeader extends ConsumerWidget {
  const PostHeader({
    super.key,
    required this.post,
    required this.isNew,
    required this.isEditing,
  });

  final Post post;
  final bool isNew;
  final bool isEditing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileProvider = ref.watch(fileNotifierProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: SizedBox(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(post.creator.userId),
            if (isNew)
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      if (fileProvider.file != null) {
                        await fileProvider.uploadFile();
                        final imagePost = post.copyWith(content: fileProvider.downloadUrl);
                        ref.read(postProvider.notifier).addPost(imagePost);
                        fileProvider.setFile(null);

                        if (context.mounted) Navigator.pop(context);
                      } else {
                        ref.read(postProvider.notifier).addPost(post);
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      if (fileProvider.file == null) {
                        fileProvider.pickFile();
                      } else {
                        fileProvider.setFile(null);
                      }
                    },
                    icon: fileProvider.file == null ? const Icon(Icons.image) : const Icon(Icons.article),
                  )
                ],
              )
            else if (ref.watch(authProvider).value?.uid == post.creator.uid)
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      if (isEditing) {
                        if (fileProvider.file != null) {
                          await fileProvider.uploadFile();
                          final imagePost = post.copyWith(content: fileProvider.downloadUrl);
                          ref.read(postProvider.notifier).updatePost(imagePost);
                          fileProvider.setFile(null);

                          if (context.mounted) Navigator.pop(context);
                        } else {
                          ref.read(postProvider.notifier).updatePost(post);
                          Navigator.pop(context);
                        }
                      } else {
                        context.push("/save", extra: post);
                      }
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  if (isEditing)
                    IconButton(
                      onPressed: () {
                        if (fileProvider.file == null) {
                          fileProvider.pickFile();
                        } else {
                          fileProvider.setFile(null);
                          if (post.isImage) {
                            ref.read(contentController.notifier).state.clear();
                          }
                        }
                      },
                      icon: fileProvider.file == null ? const Icon(Icons.image) : const Icon(Icons.article),
                    )
                  else
                    IconButton(
                      onPressed: () => ref.read(postProvider.notifier).deletePost(post),
                      icon: const Icon(Icons.delete),
                    )
                ],
              )
          ],
        ),
      ),
    );
  }
}
