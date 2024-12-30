import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/core/design_system/foundation/spacing.dart';
import 'package:pickture/providers/auth_provider.dart';
import 'package:pickture/providers/page_provider.dart';
import 'package:pickture/screens/auth/sign_up/sign_up_pages/first_page.dart';
import 'package:pickture/screens/auth/sign_up/sign_up_pages/second_page.dart';
import 'package:pickture/screens/auth/sign_up/sign_up_pages/third_page.dart';
import 'package:pickture/screens/auth/sign_up/sign_up_pages/fourth_page.dart';
import 'package:pickture/widgets/button/expanded_outlined_progress_button.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  static const int _pageCount = 4;
  final _pageNotifierProvider = ChangeNotifierProvider((ref) => PageNotifier(pageCount: _pageCount));
  final _textControllers = List.generate(_pageCount, (index) => TextEditingController());
  final _errorMessageProvider = List.generate(_pageCount, (index) => StateProvider<String?>((ref) => null));
  final _obscurePasswordProvider = StateProvider<bool>((ref) => true);

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _pageCount; i++) {
      _textControllers[i].addListener(() {
        ref.read(_errorMessageProvider[i].notifier).state = null;
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var pageProvider = ref.watch(_pageNotifierProvider);
    var emailError = ref.watch(_errorMessageProvider[0]);
    var passwordError = ref.watch(_errorMessageProvider[1]);
    var dobError = ref.watch(_errorMessageProvider[2]);
    var nameError = ref.watch(_errorMessageProvider[3]);
    var obscurePassword = ref.watch(_obscurePasswordProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: pageProvider.currentPage == 0 ? context.pop : pageProvider.toPreviousPage,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: AppSpacing.paddingAll,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageProvider.pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: pageProvider.setCurrentPage,
                children: [
                  FirstPage(
                    controller: _textControllers[0],
                    errorMessage: emailError,
                  ),
                  SecondPage(
                    controller: _textControllers[1],
                    obscureText: obscurePassword,
                    onSuffixIconPressed: _togglePasswordVisibility,
                    errorMessage: passwordError,
                  ),
                  ThirdPage(
                    controller: _textControllers[2],
                    errorMessage: dobError,
                  ),
                  FourthPage(
                    controller: _textControllers[3],
                    errorMessage: nameError,
                  ),
                ],
              ),
            ),
            ExpandedOutlinedProgressButton(
              onPressed: () => _onNextButtonClicked(context, pageProvider),
              text: "다음",
              isLoading: pageProvider.isLoading,
            ),
          ],
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    ref.read(_obscurePasswordProvider.notifier).state = !ref.read(_obscurePasswordProvider);
  }

  void _onNextButtonClicked(BuildContext context, PageNotifier pageNotifier) async {
    pageNotifier.setLoading(true);

    int currentPage = pageNotifier.currentPage;
    bool isValid = await _validateCurrentPage(currentPage);

    if (isValid) {
      if (currentPage < _pageCount - 1) {
        pageNotifier.toNextPage();
      } else {
        await _completeSignUp();
      }
    }

    pageNotifier.setLoading(false);
  }

  Future<bool> _validateCurrentPage(int currentPage) async {
    var authNotifier = ref.read(authProvider.notifier);
    String inputText = _textControllers[currentPage].text;

    switch (currentPage) {
      case 0:
        bool isAvailable = await authNotifier.isEmailAvailable(inputText);
        if (!isAvailable) {
          _setError(currentPage, '이미 사용중이거나 사용할 수 없는 이메일입니다.');
          return false;
        }
      case 1:
        bool isAvailable = authNotifier.isPasswordAvailable(inputText);
        if (!isAvailable) {
          _setError(currentPage, '사용할 수 없는 비밀번호입니다.');
          return false;
        }
      default:
        if (inputText.isEmpty) {
          _setError(currentPage, '필수 항목입니다.');
          return false;
        }
    }

    return true;
  }

  Future<void> _completeSignUp() async {
    var authNotifier = ref.read(authProvider.notifier);

    await authNotifier.signUp(_textControllers[0].text, _textControllers[1].text, _textControllers[2].text, _textControllers[3].text);
    await authNotifier.fetchUserData();
  }

  void _setError(int pageIndex, String message) {
    ref.read(_errorMessageProvider[pageIndex].notifier).state = message;
  }
}
