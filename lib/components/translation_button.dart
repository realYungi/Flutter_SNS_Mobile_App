import 'package:flutter/material.dart';

class TranslationButton extends StatelessWidget {
  final double iconSize; // Add this parameter to customize the icon size

  // Add iconSize to constructor with a default value
  const TranslationButton({Key? key, this.iconSize = 12.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.g_translate),
      color: Colors.green,
      iconSize: iconSize, // Use the iconSize parameter here
      onPressed: () {
        print('Translate button pressed');
      },
    );
  }
}
