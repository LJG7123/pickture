import 'package:flutter/material.dart';
import 'package:pickture/models/user_model.dart';

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
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        radius: 20,
        backgroundImage: user.profileImage != null && user.profileImage!.isNotEmpty ? NetworkImage(user.profileImage!) : null,
        child: user.profileImage == null || user.profileImage!.isEmpty ? Icon(Icons.person, color: Theme.of(context).colorScheme.onSurface) : null,
      ),
      title: Text(
        user.name,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
      subtitle: Text(
        user.userId,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 14,
        ),
      ),
      trailing: isSelected != null
          ? Icon(
              isSelected! ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected! ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
            )
          : null,
      onTap: onTap,
    );
  }
}
