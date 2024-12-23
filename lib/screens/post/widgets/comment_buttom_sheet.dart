import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/models/comment.dart';
import 'package:pickture/models/post.dart';
import 'package:pickture/models/user_model.dart';
import 'package:pickture/providers/auth_provider.dart';
import 'package:pickture/providers/post_provider.dart';
import 'package:pickture/providers/user_provider.dart';

class CommentButtomSheet extends ConsumerStatefulWidget {
  const CommentButtomSheet({super.key, required this.post});
  final Post post;

  @override
  ConsumerState<CommentButtomSheet> createState() => _CommentButtomSheetState();
}

class _CommentButtomSheetState extends ConsumerState<CommentButtomSheet> {
  final TextEditingController commentController = TextEditingController();
  Comment? replyComment;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    final userIds = _getAllUserIds(widget.post.comments);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(userProvider.notifier).getUserModel(userIds);
      setState(() {
        _isLoading = false;
      });
    });
  }

  List<String> _getAllUserIds(List<Comment> comments) {
    List<String> userIds = [];

    for (Comment comment in comments) {
      userIds.add(comment.userId);
      if (comment.comments.isNotEmpty) {
        userIds.addAll(_getAllUserIds(comment.comments));
      }
    }

    return userIds.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(authProvider).value!.uid;
    final userModels = ref.watch(userProvider);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Comment"),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                    _buildCard(
                        userModels.firstWhere(
                            (userModel) => userModel.uid == comment.userId),
                        comment),
                    if (comment.comments.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: comment.comments.map((reply) {
                            return _buildCard(
                                userModels.firstWhere((userModel) =>
                                    userModel.uid == reply.userId),
                                comment);
                          }).toList(),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: TextField(
              controller: commentController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.people_alt),
                border: const OutlineInputBorder(),
                hintText: replyComment == null
                    ? "${widget.post.createUserModel.userId}에게 댓글 추가"
                    : "${userModels.firstWhere((userModel) => userModel.uid == replyComment!.userId).userId}에게 답글 추가",
                suffixIcon: IconButton(
                  onPressed: () => _updateComment(
                      ref, commentController, replyComment, userId),
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
              Text(
                  "${user.userId} ${comment.createdAt.toString().substring(0, 16)}"),
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
    String userId,
  ) {
    if (commentController.text.isNotEmpty) {
      final comment = Comment(
        userId: userId,
        comment: commentController.text,
        createdAt: DateTime.now(),
        comments: [],
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
