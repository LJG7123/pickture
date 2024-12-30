import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/providers/user_provider.dart';

class FollowScreen extends ConsumerWidget {
  const FollowScreen({super.key, required this.userIds, required this.isFollow});
  final List<String> userIds;
  final bool isFollow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersByIdsProvider(userIds));

    return Scaffold(
      appBar: AppBar(
        title: isFollow ? const Text("Follow") : const Text("Following"),
        centerTitle: true,
      ),
      body: usersAsync.when(
          data: (users) {
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                final user = users[index];

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 20,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  //TODO 이름 정하기
                  title: Text(user.name),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                  onTap: () => context.push("/user_post", extra: user),
                );
              },
            );
          },
          error: (error, stack) => Center(
                child: Text(
                  "사용자 정보를 불러오는데 실패했습니다.",
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          loading: () => const Center(child: CircularProgressIndicator())),
    );
  }
}
