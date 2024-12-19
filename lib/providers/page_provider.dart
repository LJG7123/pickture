import 'package:flutter/material.dart';
import 'package:pickture/providers/auth_provider.dart';

class PageNotifier extends ChangeNotifier {
  final AuthNotifier authNotifier;
  final pageController = PageController();
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final int pageCount;
  int currentPage = 0;
  bool isLoading = false;

  PageNotifier({required this.authNotifier, required this.pageCount});

  void setCurrentPage(int page) {
    currentPage = page;
    notifyListeners();
  }

  void toNextPage() {
    if (currentPage < pageCount - 1) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setCurrentPage(currentPage + 1);
    } else if (currentPage == pageCount - 1) {
      // authNotifier.signUpWithGoogle();
    }
  }

  void toPreviousPage() {
    if (currentPage > 0) {
      pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setCurrentPage(currentPage - 1);
    }
  }
}
