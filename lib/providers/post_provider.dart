import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/models/post.dart';
import 'package:pickture/services/post_service.dart';

final postProvider = StateNotifierProvider<PostNotifier, AsyncValue<List<Post>>>(
  (ref) {
    final postNotifier = PostNotifier(PostService(FirebaseFirestore.instance));
    postNotifier.getPost();
    return postNotifier;
  },
);

final postProviderUserId = StateNotifierProvider.family<PostNotifier, AsyncValue<List<Post>>, String>(
  (ref, userId) {
    final postNotifier = PostNotifier(PostService(FirebaseFirestore.instance));
    postNotifier.getPostByUserId(userId);
    return postNotifier;
  },
);

class PostNotifier extends StateNotifier<AsyncValue<List<Post>>> {
  final PostService postService;

  PostNotifier(this.postService) : super(const AsyncLoading());

  Future<void> getPost() async {
    state = const AsyncLoading();
    try {
      final posts = await postService.getPost();
      state = AsyncData(posts);
    } catch (exception, stackTrace) {
      state = AsyncError(exception, stackTrace);
    }
  }

  Future<void> getPostByUserId(String userId) async {
    state = const AsyncLoading();
    try {
      final posts = await postService.getPostByUserId(userId);
      state = AsyncData(posts);
    } catch (exception, stackTrace) {
      state = AsyncError(exception, stackTrace);
    }
  }

  Future<void> addPost(Post post) async {
    try {
      final addPost = await postService.addPost(post);
      state = AsyncData([...state.value ?? [], addPost]);
    } catch (exception, stackTrace) {
      state = AsyncError(exception, stackTrace);
    }
  }

  Future<void> updatePost(Post updatePost) async {
    try {
      await postService.updatePost(updatePost);
      state = AsyncData([
        for (Post post in state.value ?? [])
          if (post.postId == updatePost.postId) updatePost else post
      ]);
    } catch (exception, stackTrace) {
      state = AsyncError(exception, stackTrace);
    }
  }

  Future<void> deletePost(Post deletePost) async {
    try {
      await postService.deletePost(deletePost);
      state = AsyncData(
        (state.value ?? []).where((post) => post.postId != deletePost.postId).toList(),
      );
    } catch (exception, stackTrace) {
      state = AsyncError(exception, stackTrace);
    }
  }
}
