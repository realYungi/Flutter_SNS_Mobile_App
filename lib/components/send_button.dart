import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SendButton({Key? key, required this.onPressed}) : super(key: key);

  static const IconData sendRounded = IconData(0xf0147, fontFamily: 'MaterialIcons', matchTextDirection: true);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(sendRounded),
      onPressed: onPressed,
    );
  }
}
