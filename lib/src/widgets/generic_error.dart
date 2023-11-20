import 'package:flutter/material.dart';
import 'package:riverpod_infinite_scroll_pagination/src/extensions/widget.dart';

class GenericError extends StatelessWidget {
  const GenericError({
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
        icon ??
            const Icon(
              Icons.cloud_off_outlined,
              size: 80,
              color: Colors.black38,
            ),
        const SizedBox(
          height: 10,
        ),
        Text(
          message ?? 'Sorry, an error occurred',
          textAlign: TextAlign.center,
        ),
        if (onRetry != null)
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ).withPaddingTop(50),
      ],
    );
  }
}
