import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/models/post.dart';
import 'package:pickture/screens/post/widgets/post_card/widgets/post_action.dart';
import 'package:pickture/screens/post/widgets/post_card/widgets/post_content.dart';
import 'package:pickture/screens/post/widgets/post_card/widgets/post_header.dart';

class PostCard extends ConsumerWidget {
  const PostCard({super.key, required this.post, this.isNew = false});

  final Post post;
  final bool isNew;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostHeader(post: post, isNew: isNew),
            PostContent(post: post, isNew: isNew),
            if (!isNew) PostAction(post: post),
            _buildPostFooter(post),
          ],
        ),
      ),
    );
  }

  Widget _buildPostFooter(Post post) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, bottom: 16.0, top: isNew ? 16.0 : 0),
      child: Row(
        children: [
          Text(post.creator.userId),
          const SizedBox(width: 20),
          Text(post.title),
        ],
      ),
    );
  }
}
