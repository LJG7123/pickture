import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/providers/auth_provider.dart';
import 'package:pickture/providers/page_provider.dart';
import 'package:pickture/screens/auth/sign_up/sign_up_pages/page_1.dart';
import 'package:pickture/screens/auth/sign_up/sign_up_pages/page_2.dart';
import 'package:pickture/screens/auth/sign_up/sign_up_pages/page_3.dart';
import 'package:pickture/screens/auth/sign_up/sign_up_pages/page_4.dart';
import 'package:pickture/screens/auth/widgets/expanded_elevated_progress_button.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _pageNotifierProvider =
      ChangeNotifierProvider((ref) => PageNotifier(pageCount: 4));
  final _emailController = TextEditingController();
  final _emailErrorProvider = StateProvider<String?>((ref) => null);
  final _passwordController = TextEditingController();
  final _dobController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var pageProvider = ref.watch(_pageNotifierProvider);
    var emailError = ref.watch(_emailErrorProvider);

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
                  Page1(controller: _emailController, errorMessage: emailError),
                  Page2(controller: _passwordController),
                  Page3(controller: _dobController),
                  Page4(controller: _nameController),
                ],
              ),
            ),
            ExpandedElevatedProgressButton(
              onPressed: () => _onNextButtonClicked(pageProvider),
              text: "다음",
              isLoading: pageProvider.isLoading,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      ref.read(_emailErrorProvider.notifier).state = null;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _onNextButtonClicked(PageNotifier pageNotifier) async {
    bool isAvailable = false;
    pageNotifier.setLoading(true);

    switch (pageNotifier.currentPage) {
      case 0:
        isAvailable = await ref
            .read(authProvider.notifier)
            .isEmailAvailable(_emailController.text);
        if (!isAvailable) {
          ref.read(_emailErrorProvider.notifier).state =
              '이미 사용중이거나 사용할 수 없는 이메일입니다.';
        }
      default:
        isAvailable = true;
    }

    if (isAvailable) {
      pageNotifier.toNextPage();
    }
    pageNotifier.setLoading(false);
  }
}
