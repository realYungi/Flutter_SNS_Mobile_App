import 'package:flutter/material.dart';

class BookMarkButton extends StatelessWidget {
  final double iconSize; // Add this parameter to customize the icon size

  // Add iconSize to constructor with a default value
  const BookMarkButton({Key? key, this.iconSize = 24.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.bookmark),
      iconSize: iconSize, // Use the iconSize parameter here
      color: Colors.green,
      onPressed: () {
        print('Translate button pressed');
      },
    );
  }
}
