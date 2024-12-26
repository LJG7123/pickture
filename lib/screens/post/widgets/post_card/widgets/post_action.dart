import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/models/post.dart';
import 'package:pickture/screens/post/widgets/post_card/widgets/post_action_widgets/comment_button_widget.dart';
import 'package:pickture/screens/post/widgets/post_card/widgets/post_action_widgets/like_button_widget.dart';

class PostAction extends ConsumerWidget {
  const PostAction({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            LikeButtonWidget(post: post),
            CommentButtonWidget(post: post),
            TextButton.icon(
              onPressed: () {},
              label: const Text(""),
              icon: const Icon(Icons.send),
            ),
          ],
        ),
        TextButton.icon(
          onPressed: () {},
          label: const Text(""),
          icon: const Icon(Icons.bookmark_border),
        ),
      ],
    );
  }
}
