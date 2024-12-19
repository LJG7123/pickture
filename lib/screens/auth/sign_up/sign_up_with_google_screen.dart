import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/providers/auth_provider.dart';
import 'package:pickture/providers/page_provider.dart';
import 'package:pickture/screens/auth/sign_up/sign_up_with_google_pages/page_1.dart';
import 'package:pickture/screens/auth/sign_up/sign_up_with_google_pages/page_2.dart';
import 'package:pickture/widgets/expanded_elevated_progress_button.dart';

class SignUpWithGoogleScreen extends ConsumerWidget {
  SignUpWithGoogleScreen({super.key});

  final _pageNotifierProvider = ChangeNotifierProvider((ref) {
    var authNotifier = ref.read(authProvider.notifier);
    return PageNotifier(authNotifier: authNotifier, pageCount: 2);
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  Page1(controller: pageProvider.dobController),
                  Page2(controller: pageProvider.nameController),
                ],
              ),
            ),
            ExpandedElevatedProgressButton(
              onPressed: pageProvider.toNextPage,
              text: "다음",
              isLoading: pageProvider.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
