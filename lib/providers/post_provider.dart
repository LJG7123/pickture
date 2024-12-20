import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/models/post.dart';
import 'package:pickture/services/post_service.dart';

final postProvider = StateNotifierProvider<PostNotifier, List<Post>>(
    (ref) => PostNotifier(PostService(FirebaseFirestore.instance)));

class PostNotifier extends StateNotifier<List<Post>> {
  final PostService postService;

  PostNotifier(this.postService) : super([]) {
    getPost();
  }

  Future<void> getPost() async {
    final posts = await postService.getAllPost();
    state = posts;
  }

  Future<void> addPost(Post post, WidgetRef ref) async {
    await postService.addPost(post, ref);
    state = [...state, post];
  }

  Future<void> updatePost(Post updatePost) async {
    await postService.updatePost(updatePost);
    state = [
      for (Post post in state)
        if (post.postId == updatePost.postId) updatePost else post
    ];
  }

  Future<void> deletePost(Post deletePost) async {
    await postService.deletePost(deletePost);
    state = state.where((post) => post.postId != deletePost.postId).toList();
  }
}
