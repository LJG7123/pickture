import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/models/post.dart';
import 'package:pickture/providers/auth_provider.dart';
import 'package:pickture/providers/file_provider.dart';
import 'package:pickture/screens/post/widgets/post_card/post_card.dart';

final contentController = StateProvider<TextEditingController>((ref) => TextEditingController());

class SaveScreen extends ConsumerStatefulWidget {
  const SaveScreen({super.key, this.post});

  final Post? post;

  @override
  ConsumerState<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends ConsumerState<SaveScreen> {
  late TextEditingController titleController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.post?.title);

    Future.microtask(() => ref.read(contentController.notifier).state = TextEditingController(text: widget.post?.content));
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Save"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          PostCard(
            post: createPost(
              widget.post,
              titleController.text,
              ref.watch(contentController).text,
            ),
            isNew: widget.post == null,
            isEditing: true,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
                if (!canShowContent()) ...[
                  const SizedBox(height: 20),
                  TextField(
                    controller: ref.watch(contentController),
                    decoration: const InputDecoration(
                      labelText: "Content",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) {
                      setState(() {});
                    },
                  )
                ]
              ],
            ),
          )
        ],
      ),
    );
  }

  bool canShowContent() {
    final isPostNull = widget.post == null;

    final isFileNull = ref.watch(fileNotifierProvider).file == null;
    final isContentEmpty = ref.watch(contentController).text.isEmpty;

    if (isPostNull) {
      return !isFileNull;
    } else {
      if (widget.post!.isImage) {
        return !isContentEmpty;
      } else {
        return !isFileNull;
      }
    }
  }

  Post createPost(Post? post, String title, String content) {
    return Post(
      postId: post?.postId ?? "",
      title: title,
      content: content,
      likes: post?.likes ?? [],
      comments: post?.comments ?? [],
      creator: post?.creator ?? ref.watch(authProvider).value!,
      createdAt: post?.createdAt ?? DateTime.now(),
      updatedAt: post == null ? null : DateTime.now(),
    );
  }
}
