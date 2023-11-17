import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator.adaptive();
  }

  static Widget get small {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator.adaptive(),
    );
  }
}
