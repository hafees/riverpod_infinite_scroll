import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }

  static Widget get small {
    return SizedBox(
      width: 20,
      height: 20,
      child: Platform.isIOS
          ? const CupertinoActivityIndicator()
          : const CircularProgressIndicator(),
    );
  }
}
