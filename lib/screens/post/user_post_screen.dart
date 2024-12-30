import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/core/design_system/foundation/spacing.dart';
import 'package:pickture/models/user_model.dart';
import 'package:pickture/providers/auth_provider.dart';
import 'package:pickture/providers/post_provider.dart';
import 'package:pickture/screens/auth/widgets/auth_text_field.dart';
import 'package:pickture/screens/post/widgets/post_card/post_card.dart';
import 'package:pickture/services/user_service.dart';
import 'package:pickture/widgets/button/expanded_outlined_button.dart';

class UserPostScreen extends ConsumerWidget {
  const UserPostScreen({super.key, required this.user});
  final UserModel user;

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
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authProvider).value!;
    final postsAsync = ref.watch(postProviderUserId(currentUser.uid));

    final isCurrentUser = user.uid == currentUser.uid;
    final profileImage = user.profileImage;

    return Scaffold(
      appBar: isCurrentUser
          ? _buildAppBar(context, user.userId)
          : AppBar(
              title: Text(user.userId),
              centerTitle: true,
            ),
      body: postsAsync.when(
          data: (posts) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.push('/edit_profile_image');
                            },
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                              foregroundImage: profileImage != null && profileImage.isNotEmpty ? NetworkImage(profileImage) : null,
                              child: profileImage?.isEmpty ?? true ? const Icon(Icons.person, size: 50) : null,
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
                                "userIds": user.follow,
                                "isFollow": true,
                              },
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${user.follow.length}"),
                                const Text("팔로워"),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.push(
                              "/follow",
                              extra: {
                                "userIds": user.following,
                                "isFollow": false,
                              },
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${user.following.length}"),
                                const Text("팔로잉"),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ExpandedOutlinedButton(onPressed: ref.read(authProvider.notifier).signOut, text: '로그아웃'),
                      const SizedBox(height: AppSpacing.md),
                      if (!isCurrentUser)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _updateFollow(currentUser, user),
                                child: _isFollowing(currentUser, user) ? const Text("팔로잉") : const Text("팔로우"),
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
            );
          },
          error: (error, stack) => Center(
                child: Text(
                  "피드드 정보를 불러오는데 실패했습니다.",
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          loading: () => const Center(child: CircularProgressIndicator())),
    );
  }

  AppBar _buildAppBar(BuildContext context, String userId) {
    return AppBar(
      title: const Text("User Post"),
      centerTitle: true,
      leading: !Navigator.of(context).canPop()
          ? TextButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => const _UpdateNameDialog());
        },
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

class _UpdateNameDialog extends ConsumerStatefulWidget {
  const _UpdateNameDialog();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateNameDialogState();
}

class _UpdateNameDialogState extends ConsumerState<_UpdateNameDialog> {
  final _nameController = TextEditingController();
  final _errorMessageProvider = StateProvider<String?>((ref) => null);

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      ref.read(_errorMessageProvider.notifier).state = null;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errorMessage = ref.watch(_errorMessageProvider);
    return AlertDialog(
      title: const Text('이름 변경'),
      content: AuthTextField(controller: _nameController, hintText: '새로운 이름', errorMessage: errorMessage),
      actions: [
        TextButton(onPressed: context.pop, child: const Text('취소')),
        TextButton(
          onPressed: () async {
            if (_nameController.text.isEmpty) {
              ref.read(_errorMessageProvider.notifier).state = '이름은 공백일 수 없습니다.';
              return;
            }
            await ref.read(authProvider.notifier).updateName(_nameController.text);
            if (context.mounted) {
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('이름이 성공적으로 업데이트 되었습니다.')));
            }
          },
          child: const Text('확인'),
        ),
      ],
    );
  }
}