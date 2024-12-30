import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/models/comment.dart';
import 'package:pickture/models/post.dart';
import 'package:pickture/models/user_model.dart';
import 'package:pickture/providers/auth_provider.dart';
import 'package:pickture/providers/post_provider.dart';

class CommentButtomSheet extends ConsumerStatefulWidget {
  const CommentButtomSheet({super.key, required this.post});
  final Post post;

  @override
  ConsumerState<CommentButtomSheet> createState() => _CommentButtomSheetState();
}

class _CommentButtomSheetState extends ConsumerState<CommentButtomSheet> {
  final TextEditingController commentController = TextEditingController();
  Comment? replyComment;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(
            child: Text("댓글"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.post.comments.length,
              itemBuilder: (BuildContext context, int index) {
                final comment = widget.post.comments[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCard(comment.user!, comment),
                    if (comment.comments.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: comment.comments.map((reply) {
                            return _buildCard(reply.user!, comment);
                          }).toList(),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: TextField(
              controller: commentController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.people_alt),
                border: const OutlineInputBorder(),
                hintText: replyComment == null ? "${widget.post.creator!.userId}에게 댓글 추가" : "${replyComment!.user!.userId}에게 답글 추가",
                suffixIcon: IconButton(
                  onPressed: () => _updateComment(ref, commentController, replyComment, user),
                  icon: const Icon(Icons.upload),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(UserModel user, Comment comment) {
    return Card(
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 20,
            child: Icon(Icons.person, color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("${user.userId} ${comment.createdAt.toString().substring(0, 16)}"),
              Text(comment.comment),
              TextButton(
                onPressed: () {
                  setState(() {
                    replyComment = comment;
                  });
                },
                child: const Text("답글달기"),
              )
            ],
          )
        ],
      ),
    );
  }

  void _updateComment(
    WidgetRef ref,
    TextEditingController commentController,
    Comment? replyComment,
    UserModel user,
  ) {
    if (commentController.text.isNotEmpty) {
      final comment = Comment(
        userId: user.uid,
        comment: commentController.text,
        createdAt: DateTime.now(),
        comments: [],
        user: user,
      );

      if (replyComment == null) {
        widget.post.comments.add(comment);
      } else {
        replyComment.comments.add(comment);
      }

      final updatePost = widget.post.copyWith(comments: widget.post.comments);
      ref.read(postProvider.notifier).updatePost(updatePost);
      commentController.clear();
    }
  }
}
