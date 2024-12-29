import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/core/design_system/foundation/spacing.dart';
import 'package:pickture/providers/file_provider.dart';
import 'package:pickture/providers/router_provider.dart';

class EditProfileImageScreen extends ConsumerWidget {
  final _profileNotifierProvider = ChangeNotifierProvider<FileNotifier>((ref) => FileNotifier(ref));
  final _backgroundImgKey = GlobalKey();
  final _circleViewKey = GlobalKey();
  final _transformationController = TransformationController();

  EditProfileImageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var imageProvider = ref.watch(_profileNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("프로필 편집")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              RepaintBoundary(
                key: _backgroundImgKey,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: imageProvider.file != null
                      ? InteractiveViewer(transformationController: _transformationController, child: Image.file(imageProvider.file!))
                      : null,
                ),
              ),
              IgnorePointer(
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(Colors.black.withAlpha(200), BlendMode.srcOut),
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(color: Colors.black, backgroundBlendMode: BlendMode.dstOut),
                      ),
                      Container(
                        key: _circleViewKey,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(200),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              ref.read(_profileNotifierProvider).pickFile();
            },
            child: const Text('이미지 선택'),
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton(
            onPressed: () async {
              var profileImage = await _capturePng();
              if (profileImage == null) return;
              ref.read(_profileNotifierProvider).uploadProfileImage(profileImage).then((_) {
                if (context.mounted) {
                  ref.read(routerProvider).pop();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('프로필이 성공적으로 업데이트되었습니다.')));
                }
              });
            },
            child: const Text('저장'),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Future<Uint8List?> _capturePng() async {
    final RenderBox circleBoundary = _circleViewKey.currentContext?.findRenderObject() as RenderBox;
    final Size circleBoundarySize = circleBoundary.size;
    final RenderRepaintBoundary backgroundBoundary = _backgroundImgKey.currentContext?.findRenderObject() as RenderRepaintBoundary;

    // Background to image
    const double scale = 1.0;
    final double outputW = circleBoundarySize.width * scale;
    final double outputH = circleBoundarySize.height * scale;
    final image = await backgroundBoundary.toImage(pixelRatio: scale);

    // Edit background image
    final recorder = PictureRecorder();
    final Rect rect = Rect.fromLTWH(0, 0, outputW, outputH);
    final Canvas canvas = Canvas(recorder, rect);
    final Paint paint = Paint();

    // Clip circle
    final Path path = Path()..addOval(Rect.fromLTWH(0, 0, outputW, outputH));
    // Requires save and restore canvas to local clipPath
    canvas.save();
    canvas.clipPath(path);
    canvas.drawImageRect(image, Rect.fromLTWH(0, 0, outputW, outputH), Rect.fromLTWH(0, 0, outputW, outputH), paint);
    canvas.restore();

    // Finish edit, convert to image render
    final picture = recorder.endRecording();
    final img = await picture.toImage(rect.width.toInt(), rect.height.toInt());
    final ByteData? byteData2 = await img.toByteData(format: ImageByteFormat.png);
    final Uint8List? pngBytes2 = byteData2?.buffer.asUint8List();

    return pngBytes2;
  }
}
