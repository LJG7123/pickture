import 'package:flutter/material.dart';
import '../../../models/user_model.dart';

class UserSearchTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;
  final bool? isSelected;

  const UserSearchTile({
    super.key,
    required this.user,
    required this.onTap,
    this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: Colors.grey[800],
        radius: 20,
        backgroundImage:
            user.profileImage != null && user.profileImage!.isNotEmpty
                ? NetworkImage(user.profileImage!)
                : null,
        child: user.profileImage == null || user.profileImage!.isEmpty
            ? const Icon(Icons.person, color: Colors.white)
            : null,
      ),
      title: Text(
        user.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
      subtitle: Text(
        user.userId,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
        ),
      ),
      trailing: isSelected != null
          ? Icon(
              isSelected! ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected! ? Colors.blue : Colors.grey,
            )
          : null,
      onTap: onTap,
    );
  }
}
