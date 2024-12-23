import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/providers/auth_provider.dart';
import 'package:pickture/providers/page_provider.dart';
import 'package:pickture/screens/auth/sign_up/sign_up_with_google_pages/page_1.dart';
import 'package:pickture/screens/auth/sign_up/sign_up_with_google_pages/page_2.dart';
import 'package:pickture/screens/auth/widgets/expanded_elevated_progress_button.dart';

class SignUpWithGoogleScreen extends ConsumerStatefulWidget {
  const SignUpWithGoogleScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SignUpWithGoogleScreenState();
}

class _SignUpWithGoogleScreenState extends ConsumerState {
  final _pageNotifierProvider =
      ChangeNotifierProvider((ref) => PageNotifier(pageCount: 2));
  final _dobController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var pageProvider = ref.watch(_pageNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: pageProvider.currentPage == 0
              ? context.pop
              : pageProvider.toPreviousPage,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageProvider.pageController,
                onPageChanged: pageProvider.setCurrentPage,
                children: [
                  Page1(controller: _dobController),
                  Page2(controller: _nameController),
                ],
              ),
            ),
            ExpandedElevatedProgressButton(
              onPressed: pageProvider.currentPage < pageProvider.pageCount - 1
                  ? pageProvider.toNextPage
                  : () {
                      ref
                          .read(authProvider.notifier)
                          .signUpWithGoogle(
                            _dobController.text,
                            _nameController.text,
                          )
                          .then((value) {
                        if (ref.read(authProvider).value != null) {
                          if (context.mounted) context.go('/post');
                        }
                      });
                    },
              text: "다음",
              isLoading: pageProvider.isLoading,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dobController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
