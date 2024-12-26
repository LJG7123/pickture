import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/models/post.dart';
import 'package:pickture/providers/auth_provider.dart';
import 'package:pickture/providers/post_provider.dart';
import 'package:pickture/providers/file_provider.dart';

class PostHeader extends ConsumerWidget {
  const PostHeader({super.key, required this.post, required this.isNew});

  final Post post;
  final bool isNew;

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
                    onPressed: fileProvider.pickFile,
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
            else if (ref.watch(authProvider).value!.uid == post.creator.uid)
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.push("/save", extra: post),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () => ref.read(postProvider.notifier).deletePost(post),
                    icon: const Icon(Icons.delete),
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
          ],
        ),
      ),
    );
  }
}
