import 'package:flutter/material.dart';

extension ContextUtils on BuildContext {
  TextStyle get headingTextStyle => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Theme.of(this).colorScheme.primary,
      );

  TextStyle get summaryTextStyle => const TextStyle(
        fontSize: 11,
        //color: Theme.of(this).colorScheme.primary,
      );

  TextStyle get infoTextStyle => const TextStyle(
        fontSize: 11,
        //color: Theme.of(this).colorScheme.primary,
      );
}
