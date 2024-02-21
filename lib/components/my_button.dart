import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  
  final Function()? onTap;
  final String text;
  const MyButton({super.key, required this.onTap, required this.text,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 0, 143, 2),
          borderRadius: BorderRadius.circular(16),
          ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
      
            ),
            )
          
          
          ),
      ),
    );
  }
}
