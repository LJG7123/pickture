import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/models/like.dart';
import 'package:pickture/models/user_model.dart';
import 'package:pickture/providers/user_provider.dart';

class LikeScreen extends ConsumerStatefulWidget {
  const LikeScreen({super.key, required this.likes});
  final List<Like> likes;

  @override
  ConsumerState<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends ConsumerState<LikeScreen> {
  bool _isLoading = true;
  List<String> _userIds = [];

  @override
  void initState() {
    super.initState();
    final userIds = widget.likes.map((like) => like.userId).toList();
    _userIds = userIds;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (final userId in userIds) {
        await ref.read(userProvider(userId).future);
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Like"),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 사용자 정보 가져오기
    final userAsyncValues = _userIds.map((id) => ref.watch(userProvider(id)));

    // 모든 사용자 정보가 로드될 때까지 대기
    final hasError = userAsyncValues.any((async) => async.hasError);
    final isLoading = userAsyncValues.any((async) => async.isLoading);

    if (hasError) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Like"),
          centerTitle: true,
        ),
        body: const Center(
          child: Text("사용자 정보를 불러오는데 실패했습니다."),
        ),
      );
    }

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Like"),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final users = userAsyncValues
        .map((async) => async.value)
        .where((user) => user != null)
        .cast<UserModel>()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Like"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget.likes.length,
        itemBuilder: (BuildContext context, int index) {
          final like = widget.likes[index];
          final user = users.firstWhere(
            (userModel) => userModel.uid == like.userId,
          );

          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: const CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 20,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              user.email.split('@')[0],
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
            onTap: () {},
          );
        },
      ),
    );
  }
}
