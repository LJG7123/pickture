import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/models/like.dart';
import 'package:pickture/models/post.dart';
import 'package:pickture/providers/auth_provider.dart';
import 'package:pickture/providers/post_provider.dart';

class LikeButtonWidget extends ConsumerWidget {
  const LikeButtonWidget({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value!;
    final isLiked = post.likes.any((like) => like.userId == user.uid);

    return TextButton.icon(
      onPressed: () {},
      icon: GestureDetector(
        onTap: () {
          if (isLiked) {
            post.likes.removeWhere((like) => like.userId == user.uid);
          } else {
            final like = Like(
              userId: user.uid,
              createdAt: DateTime.now(),
              user: user,
            );
            post.likes.add(like);
          }

          final updatePost = post.copyWith(likes: post.likes);
          ref.read(postProvider.notifier).updatePost(updatePost);
        },
        child: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
      ),
      label: GestureDetector(
        onTap: () => context.push("/like", extra: post.likes),
        child: Text("${post.likes.length}"),
      ),
    );
  }
}
