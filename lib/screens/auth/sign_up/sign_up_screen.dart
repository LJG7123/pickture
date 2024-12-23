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
  static const int _pageCount = 4;
  final _pageNotifierProvider =
      ChangeNotifierProvider((ref) => PageNotifier(pageCount: _pageCount));
  final _textControllers =
      List.generate(_pageCount, (index) => TextEditingController());
  final _errorMessageProvider = List.generate(
      _pageCount, (index) => StateProvider<String?>((ref) => null));

  @override
  Widget build(BuildContext context) {
    var pageProvider = ref.watch(_pageNotifierProvider);
    var emailError = ref.watch(_errorMessageProvider[0]);
    var passwordError = ref.watch(_errorMessageProvider[1]);
    var dobError = ref.watch(_errorMessageProvider[2]);
    var nameError = ref.watch(_errorMessageProvider[3]);

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
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: pageProvider.setCurrentPage,
                children: [
                  Page1(
                    controller: _textControllers[0],
                    errorMessage: emailError,
                  ),
                  Page2(
                    controller: _textControllers[1],
                    errorMessage: passwordError,
                  ),
                  Page3(
                    controller: _textControllers[2],
                    errorMessage: dobError,
                  ),
                  Page4(
                    controller: _textControllers[3],
                    errorMessage: nameError,
                  ),
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

  void _onNextButtonClicked(PageNotifier pageNotifier) async {
    bool isAvailable = false;
    pageNotifier.setLoading(true);
    var authNotifier = ref.read(authProvider.notifier);
    var currentPage = pageNotifier.currentPage;

    switch (currentPage) {
      case 0:
        isAvailable =
            await authNotifier.isEmailAvailable(_textControllers[0].text);
        if (!isAvailable) {
          ref.read(_errorMessageProvider[0].notifier).state =
              '이미 사용중이거나 사용할 수 없는 이메일입니다.';
        }
      case 1:
        isAvailable =
            authNotifier.isPasswordAvailable(_textControllers[1].text);
        if (!isAvailable) {
          ref.read(_errorMessageProvider[1].notifier).state =
              '사용할 수 없는 비밀번호입니다.';
        }
      default:
        isAvailable = _textControllers[currentPage].text.isNotEmpty;
        if (!isAvailable) {
          ref.read(_errorMessageProvider[currentPage].notifier).state =
              '필수 항목입니다.';
        }
    }

    if (isAvailable) {
      if (currentPage < _pageCount - 1) {
        pageNotifier.toNextPage();
      } else {

      }
    }
    pageNotifier.setLoading(false);
  }
}
