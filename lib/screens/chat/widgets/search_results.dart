import 'package:flutter/material.dart';
import '../../../models/user_model.dart';

typedef OnUserTapCallback = Future<void> Function(UserModel contact);

class SearchResults extends StatelessWidget {
  final List<UserModel> contacts;
  final OnUserTapCallback onUserTap;

  const SearchResults({
    super.key,
    required this.contacts,
    required this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
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
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[800],
            backgroundImage:
                contact.profileImage != null && contact.profileImage!.isNotEmpty
                    ? NetworkImage(contact.profileImage!)
                    : null,
            child: contact.profileImage == null || contact.profileImage!.isEmpty
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
          title: Text(
            contact.name,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            contact.userId,
            style: TextStyle(color: Colors.grey[400]),
          ),
          onTap: () => onUserTap(contact),
        );
      },
    );
  }
}
