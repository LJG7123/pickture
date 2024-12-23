import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/models/comment.dart';
import 'package:pickture/models/post.dart';
import 'package:pickture/screens/post/widgets/comment_buttom_sheet.dart';

class CommentButtonWidget extends ConsumerWidget {
  const CommentButtonWidget({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton.icon(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return CommentButtomSheet(post: post);
          },
        );
      },
      label: Text("${_calculateTotalComments(post.comments)}"),
      icon: const Icon(Icons.mode_comment_outlined),
    );
  }

  int _calculateTotalComments(List<Comment> comments) {
    int totalCount = 0;

    for (Comment comment in comments) {
      totalCount++;
      if (comment.comments.isNotEmpty) {
        totalCount += _calculateTotalComments(comment.comments);
      }
    }

    return totalCount;
  }
}
