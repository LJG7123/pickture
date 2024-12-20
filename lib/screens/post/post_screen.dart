import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/models/post.dart';
import 'package:pickture/providers/auth_provider.dart';
import 'package:pickture/providers/post_provider.dart';

class PostScreen extends ConsumerWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Post"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => _saveDialog(context, ref),
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            final post = posts[index];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: SizedBox(
                        height: 48,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(post.createUserModel.email.split('@')[0]),
                            if (ref.watch(authProvider)!.uid ==
                                post.createUserModel.uid)
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        _saveDialog(context, ref, post),
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () => ref
                                        .read(postProvider.notifier)
                                        .deletePost(post),
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 150,
                        color: Colors.grey,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Image or Content"),
                              Text(post.content),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton.icon(
                              onPressed: () {},
                              label: GestureDetector(
                                onTap: () {},
                                child: Text("${post.likes.length}"),
                              ),
                              icon: GestureDetector(
                                onTap: () {},
                                child: const Icon(Icons.favorite),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {},
                              label: Text("${post.comments.length}"),
                              icon: const Icon(Icons.mode_comment_outlined),
                            ),
                            TextButton.icon(
                              onPressed: () {},
                              label: const Text(""),
                              icon: const Icon(Icons.send),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          label: const Text(""),
                          icon: const Icon(Icons.bookmark_border),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                      child: Text(
                        "${post.createUserModel.email.split('@')[0]} ${post.title}",
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void _saveDialog(BuildContext context, WidgetRef ref, [Post? post]) {
  final titleController = TextEditingController(text: post?.title);
  final contentController = TextEditingController(text: post?.content);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(post == null ? "Add Post" : "Edit Post"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: "Content"),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final savePost = createPost(
                  post, titleController.text, contentController.text, ref);
              if (post == null) {
                ref.read(postProvider.notifier).addPost(savePost);
              } else {
                ref.read(postProvider.notifier).updatePost(savePost);
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Calcel"),
          ),
        ],
      );
    },
  );
}

Post createPost(Post? post, String title, String content, WidgetRef ref) {
  return Post(
    postId: post?.postId ?? "",
    title: title,
    content: content,
    likes: post?.likes ?? [],
    comments: post?.comments ?? [],
    createUserModel: post?.createUserModel ?? ref.watch(authProvider)!,
    createdAt: post?.createdAt ?? DateTime.now(),
    updatedAt: post == null ? null : DateTime.now(),
  );
}
