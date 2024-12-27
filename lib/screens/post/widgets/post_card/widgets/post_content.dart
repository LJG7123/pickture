import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/models/post.dart';
import 'package:pickture/providers/file_provider.dart';

class PostContent extends ConsumerWidget {
  const PostContent({super.key, required this.post, required this.isNew});

  final Post? post;
  final bool isNew;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileProvider = ref.watch(fileNotifierProvider);

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 150,
        color: Colors.grey,
        child: isNew
            ? fileProvider.file != null
                ? _buildImageFile(fileProvider)
                : _buildTextContent()
            : post!.isImage
                ? fileProvider.file != null
                    ? _buildImageFile(fileProvider)
                    : _buildImageContent()
                : fileProvider.file != null
                    ? _buildImageFile(fileProvider)
                    : _buildTextContent(),
      ),
    );
  }

  Widget _buildImageFile(FileNotifier fileProvider) {
    return IntrinsicHeight(
      child: Image.file(
        fileProvider.file!,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildImageContent() {
    return IntrinsicHeight(
      child: Image.network(
        post!.content,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildTextContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          post!.content == "" ? const Text("Image or Content") : Text(post!.content),
        ],
      ),
    );
  }
}
