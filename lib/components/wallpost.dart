import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uridachi/components/like_button.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;



  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,

    });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {

  //getting the user from firebase
  final currenUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currenUser.email);

  }


  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef = 
    FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    //if liked, add the user's email to the Likes field
    if (isLiked) {
      postRef.update({
        'Likes' : FieldValue.arrayUnion([currenUser.email])
      });
    } else {
      postRef.update({
        'Likes' : FieldValue.arrayRemove([currenUser.email])
      });

    }


  }

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

          const SizedBox(width: 20),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user,
                style: TextStyle(color: Colors.grey[300]),
                ),
              SizedBox(height: 10,),

              Text(widget.message),


            ],
          ),

          const SizedBox(width: 40),

          Column(
            children: [
              LikeButton(
                isLiked: isLiked, onTap: toggleLike,
              ),

              const SizedBox(height: 5,),

              Text(
                widget.likes.length.toString(),
                style: TextStyle(color: Colors.grey,),
                
                ),

            ],
          ),



        ],
      ),
    );
  }
}