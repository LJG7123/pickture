import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/models/user_model.dart';
import 'package:pickture/providers/auth_provider.dart';
import 'package:pickture/providers/post_provider.dart';
import 'package:pickture/screens/post/widgets/post_card/post_card.dart';
import 'package:pickture/services/user_service.dart';

class UserPostScreen extends ConsumerStatefulWidget {
  const UserPostScreen({super.key, required this.user});
  final UserModel user;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserPostScreenState();
}

class _UserPostScreenState extends ConsumerState<UserPostScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPost();
  }

  Future<void> _fetchPost() async {
    await ref.read(postProvider.notifier).getPostByUserId(widget.user.uid);
    setState(() {
      isLoading = false;
    });
  }

  bool _isFollowing(UserModel currentUser, UserModel followingUser) {
    return currentUser.following.contains(followingUser.uid);
  }

  void _updateFollow(UserModel currentUser, UserModel followingUser) {
    final followingByCurrentUser = currentUser.following;
    final followByFollowingUser = followingUser.follow;

    if (_isFollowing(currentUser, followingUser)) {
      followingByCurrentUser.remove(followingUser.uid);
      followByFollowingUser.remove(currentUser.uid);
    } else {
      followingByCurrentUser.add(followingUser.uid);
      followByFollowingUser.add(currentUser.uid);
    }

    Map<String, List<String>> currentUserFollowing = {currentUser.uid: currentUser.following};
    Map<String, List<String>> followingUserFollow = {followingUser.uid: followByFollowingUser};

    final userService = UserService();
    userService.updateFollow(currentUserFollowing, followingUserFollow);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authProvider).value!;
    final posts = ref.watch(postProvider);

    final isCurrentUser = widget.user.uid == currentUser.uid;

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: isCurrentUser
          ? _buildAppBar(context, widget.user.userId)
          : AppBar(
              title: Text(widget.user.userId),
              centerTitle: true,
            ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 30,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${posts.length}"),
                          const Text("게시물"),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push(
                        "/follow",
                        extra: {
                          "userIds": widget.user.follow,
                          "isFollow": true,
                        },
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${widget.user.follow.length}"),
                          const Text("팔로워"),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push(
                        "/follow",
                        extra: {
                          "userIds": widget.user.following,
                          "isFollow": false,
                        },
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${widget.user.following.length}"),
                          const Text("팔로잉"),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (!isCurrentUser)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _updateFollow(currentUser, widget.user),
                          child: _isFollowing(currentUser, widget.user) ? const Text("팔로잉") : const Text("팔로우"),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text("메시지"),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) {
                final post = posts[index];
                return PostCard(post: post);
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, String userId) {
    return AppBar(
      title: const Text("User Post"),
      centerTitle: true,
      leading: !Navigator.of(context).canPop()
          ? TextButton(
              onPressed: () {},
              child: Text(userId),
            )
          : null,
      actions: [
        Row(
          children: [
            IconButton(
              onPressed: () => context.push("/save", extra: null),
              icon: const Icon(Icons.add),
            ),
            IconButton(
              onPressed: () => context.push('/chats'),
              icon: const Icon(Icons.messenger_outline),
            ),
          ],
        )
      ],
    );
  }
}
