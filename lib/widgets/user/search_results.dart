import 'package:flutter/material.dart';
import '../../models/user_model.dart';

typedef OnUserTapCallback = Future<void> Function(UserModel contact);
typedef ItemBuilder = Widget Function(BuildContext context, UserModel user);

class SearchResults extends StatelessWidget {
  final List<UserModel> contacts;
  final ItemBuilder itemBuilder;
  final bool isSearching;

  const SearchResults({
    super.key,
    required this.contacts,
    required this.itemBuilder,
    this.isSearching = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isSearching) {
      return const Center(
        child: Text(
          '사용자를 검색해보세요',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    if (contacts.isEmpty) {
      return const Center(
        child: Text(
          '검색 결과가 없습니다',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) => itemBuilder(context, contacts[index]),
    );
  }
}
