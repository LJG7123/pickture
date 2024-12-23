import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/models/like.dart';
import 'package:pickture/providers/user_provider.dart';

class LikeScreen extends ConsumerStatefulWidget {
  const LikeScreen({super.key, required this.likes});
  final List<Like> likes;

  @override
  ConsumerState<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends ConsumerState<LikeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    final userIds = widget.likes.map((like) => like.userId).toList();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(userProvider.notifier).getUserModel(userIds);
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userModels = ref.watch(userProvider);

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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Like"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget.likes.length,
        itemBuilder: (BuildContext context, int index) {
          final like = widget.likes[index];
          final user = userModels.firstWhere(
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
