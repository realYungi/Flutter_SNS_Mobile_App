import 'package:flutter/material.dart';

class WallPost extends StatelessWidget {
  final String message;
  final String user;

  const WallPost({
    super.key,
    required this.message,
    required this.user,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

      ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Row(
        children: [

          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[400]),
            padding: EdgeInsets.all(10),
            child: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user,
                style: TextStyle(color: Colors.grey[300]),
                ),
              SizedBox(height: 10,),

              Text(message),


            ],
          ),
        ],
      ),
    );
  }
}