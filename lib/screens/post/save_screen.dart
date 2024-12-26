import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/models/post.dart';
import 'package:pickture/providers/auth_provider.dart';
import 'package:pickture/providers/file_provider.dart';
import 'package:pickture/screens/post/widgets/post_card/post_card.dart';

class SaveScreen extends ConsumerStatefulWidget {
  const SaveScreen({super.key, this.post});

  final Post? post;

  @override
  ConsumerState<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends ConsumerState<SaveScreen> {
  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: widget.post?.title);
    final contentController = TextEditingController(text: widget.post?.content);

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
              widget.post?.content ?? contentController.text,
            ),
            isNew: true, //widget.post == null ? true : false,
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
                if (!testCode()) ...[
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: contentController,
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

  bool testCode() {
    if (widget.post == null) {
      if (ref.watch(fileNotifierProvider).file == null) {
        //텍스트 필드 보여줘야함
        return false;
      }
    } else {
      if (widget.post!.content.startsWith("https://firebasestorage")) {
        if (ref.watch(fileNotifierProvider).file == null) {
          //텍스트 필드 보여줘야함
          return false;
        } else {
          //텍스트 필드 보여주고 초기화
          setState(() {});
        }
      } else {
        if (ref.watch(fileNotifierProvider).file == null) {
          //텍스트 필드 보여줘야함
          return false;
        }
      }
    }

    return true;
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
