import 'package:flutter/material.dart';
import 'package:riverpod_infinite_scroll_pagination/src/extensions/widget.dart';

class NoItemsFound extends StatelessWidget {
  const NoItemsFound({
    super.key,
    this.onRetry,
    this.message,
    this.icon,
  });
  final VoidCallback? onRetry;
  final String? message;
  final Widget? icon;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon ?? const Icon(Icons.hourglass_bottom),
        const SizedBox(
          height: 10,
        ),
        Text(
          message ?? 'Sorry, no items found',
          textAlign: TextAlign.center,
        ),
        if (onRetry != null)
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Try again'),
          ).withPaddingTop(50),
      ],
    );
  }
}
