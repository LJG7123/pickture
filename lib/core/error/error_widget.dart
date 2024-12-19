import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'error_provider.dart';

class GlobalErrorWidget extends ConsumerWidget {
  const GlobalErrorWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(errorNotifierProvider, (previous, next) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: '확인',
              textColor: Colors.white,
              onPressed: () {
                ref.read(errorNotifierProvider.notifier).clearError();
              },
            ),
          ),
        );
      }
    });

    return child;
  }
} 