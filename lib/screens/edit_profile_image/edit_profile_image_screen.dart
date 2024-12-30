import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/core/design_system/foundation/spacing.dart';
import 'package:pickture/providers/auth_provider.dart';
import 'package:pickture/providers/file_provider.dart';
import 'package:pickture/widgets/button/expanded_outlined_button.dart';
import 'package:pickture/widgets/button/expanded_outlined_progress_button.dart';

class EditProfileImageScreen extends ConsumerWidget {
  final _profileNotifierProvider = ChangeNotifierProvider<FileNotifier>((ref) => FileNotifier(ref));
  final _backgroundImgKey = GlobalKey();
  final _circleViewKey = GlobalKey();
  final _transformationController = TransformationController();
  final _saveLoadingProvider = StateProvider<bool>((ref) => false);

  EditProfileImageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var image = ref.watch(_profileNotifierProvider).file;
    var isLoading = ref.watch(_saveLoadingProvider);

    ref.listen(_profileNotifierProvider.select((value) => value.file), (previous, next) {
      _transformationController.value.setValues(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
    });

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
                  child: image != null
                      ? InteractiveViewer(maxScale: 4.0, transformationController: _transformationController, child: Image.file(image))
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
          Padding(
            padding: AppSpacing.paddingHorizontal,
            child: ExpandedOutlinedButton(
              onPressed: ref.read(_profileNotifierProvider).pickFile,
              text: '이미지 선택',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: AppSpacing.paddingHorizontal,
            child: ExpandedOutlinedProgressButton(
              onPressed: () => _onSaveButtonPressed(context, ref),
              text: '저장',
              isLoading: isLoading,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  void _onSaveButtonPressed(BuildContext context, WidgetRef ref) async {
    if (ref.read(_profileNotifierProvider).file == null) {
      // 이미지가 선택되지 않았을 때
      await showDialog(context: context, builder: (context) => _imageUnpickedDialog(context, ref));
      return;
    }

    ref.read(_saveLoadingProvider.notifier).state = true;

    var profileImage = await _capturePng();
    if (profileImage == null) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('오류가 발생했습니다. 다시 시도해 주세요.')));
      return;
    }
    await ref.read(_profileNotifierProvider).uploadProfileImage(profileImage).then((_) {
      if (context.mounted) {
        context.go('/home');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('프로필이 성공적으로 업데이트 되었습니다.')));
      }
    });

    ref.read(_saveLoadingProvider.notifier).state = false;
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

  AlertDialog _imageUnpickedDialog(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('알림'),
      content: const Text('이미지가 선택되지 않았습니다. 프로필 사진을 초기화 하시겠습니까?'),
      actions: [
        TextButton(onPressed: context.pop, child: const Text('취소')),
        TextButton(
          onPressed: () async {
            await ref.read(authProvider.notifier).updateProfileImage(null);
            if (context.mounted) {
              context.go('/home');
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('프로필이 성공적으로 업데이트 되었습니다.')));
            }
          },
          child: const Text('확인'),
        ),
      ],
    );
  }
}
