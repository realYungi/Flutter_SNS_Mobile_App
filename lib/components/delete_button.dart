import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  void Function()? onTap;

  DeleteButton({
    super.key,
    required this.onTap,
    
    });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(
        Icons.cancel,
        color: Colors.grey,
      ),
    );
  }
}