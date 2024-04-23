import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uridachi/components/bookmark_button.dart';
import 'package:uridachi/components/comment.dart';
import 'package:uridachi/components/comment_button.dart';
import 'package:uridachi/components/delete_button.dart';
import 'package:uridachi/components/like_button.dart';
import 'package:uridachi/components/send_button.dart';
import 'package:uridachi/components/translation_button.dart';
import 'package:uridachi/screen/coment_screen.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';




//where our posts are posted
class TextPost extends StatefulWidget {
    final String titleofpost;
    final String content;
    final String user;
    final String time;
    final String postId;
    final List<String> likes;




  const TextPost({
    super.key,
    required this.titleofpost,
    required this.content,
    required this.user,
    required this.time,
    required this.postId,
    required this.likes,
 
});

  @override
  State<TextPost> createState() => _TextPostState();
}

class _TextPostState extends State<TextPost> {
  late List<String> likes;
  bool isLiked = false;
  final currentUser = FirebaseAuth.instance.currentUser!;

  final _commentTextController = TextEditingController();
  bool isTranslating = false;

  late String translatedTitle;
  late String translatedContent;

  @override
  void initState () {
    super.initState();
    likes = List.from(widget.likes); // Initialize local likes list
    isLiked = likes.contains(currentUser.email);
    translatedTitle = widget.titleofpost;
    translatedContent = widget.content;
  }

 

 void toggleLike() async {
    final userEmail = currentUser.email ?? "";
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        likes.add(userEmail);
      } else {
        likes.remove(userEmail);
      }
    });

    DocumentReference postRef = FirebaseFirestore.instance.collection('Social Posts').doc(widget.postId);

    if (isLiked) {
      postRef.update({'Likes': FieldValue.arrayUnion([userEmail])});
    } else {
      postRef.update({'Likes': FieldValue.arrayRemove([userEmail])});
    }
  }


  void addComment (String commentText) {
    //saving to firestore under "comments section"
    FirebaseFirestore.instance
    .collection("Social Posts")
    .doc(widget.postId)
    .collection("comment")
    .add({
      "CommentText" : commentText,
      "CommentedBy" : currentUser.email,
      "CommentTime" : Timestamp.now(),
    });

  } 


  void showCommentDialog() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("Add Comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: const InputDecoration(
            hintText: "Write a comment",

          ),
          
        ),

        actions: [
        

          TextButton(
            onPressed: (){
              Navigator.pop(context);

              _commentTextController.clear();
            },
            child: const Text("Cancel"),
          ),

            TextButton(
            onPressed: () {
              addComment(_commentTextController.text);
              Navigator.pop(context);

              _commentTextController.clear();

            },
            child: const Text("Post Message"),
          ),


        ],
      ),
    );
  }



  void deletePost () {
    //show a dialog to confirm the delete process
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text("Are you sure you want to delete it?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),

          TextButton(onPressed: () async{
            //delete comment from firestore
            final commentDocs = await FirebaseFirestore.instance.
            collection("Social Posts")
            .doc(widget.postId)
            .collection("comment").get();

            for (var doc in commentDocs.docs) {
              await FirebaseFirestore.instance.collection("Social Posts")
              .doc(widget.postId)
              .collection("comment")
              .doc(doc.id)
              .delete();
            }


            //delete post
            FirebaseFirestore.instance.collection("Social Posts").doc(widget.postId)
            .delete().then((value) => print("Post Deleted"))
            .catchError((error) => print("Failed to Delete : $error"));


            Navigator.pop(context);



          }, child: const Text("Delete")),
        ],
      )
    );


  }




  @override
  Widget build(BuildContext context) {
    Color baseColor = Color.fromARGB(255, 255, 255, 255);


    return Padding(
        padding: const EdgeInsets.only(top: 25, left: 25, right: 25),      
        child: Container(
          decoration: BoxDecoration(
    color: baseColor, // Set the background color of the container
    borderRadius: BorderRadius.circular(20), // Set the border radius
    boxShadow: [
      BoxShadow(
        color: Color.fromARGB(255, 233, 233, 233).withOpacity(0.5), // Shadow color with opacity
        spreadRadius: 3, // Spread radius
        blurRadius: 5, // Blur radius
        offset: Offset(0, 0), // Shadow position
      ),
    ],
  ),


          child: Padding(
  padding: const EdgeInsets.all(25),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                


          Row(
            children: [

              if (widget.user == currentUser.email)
             DeleteButton(onTap: deletePost),


              Column(
                children: [
                  Column(
                      children: [
                        Text( widget.time, style: TextStyle(color: Colors.grey[400]),),
                      ],
                    ),

                    SizedBox(height: 10,),
                  
                        Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: Text(
                            widget.titleofpost,
                            style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            maxLines: null,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: Text(
                            widget.content,
                            style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 175, 175, 175)),
                            textAlign: TextAlign.center,
                            maxLines: null,
                          ),
                        ),
                ],
              ),

                Container(
    width: 18, // Width of the container
    height: 100, // Height of the container
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 210, 210, 210),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TranslationButton(iconSize: 18,), // Smaller size to fit the container
      
      ],
    ),
  ),
            ],
          ),
                const SizedBox(height: 10),
              ],
            ),
          ),

         





        ],
      ),

      SizedBox(height: 20,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Text(
                widget.user,
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),
          const SizedBox(width: 110),
          Row(
            children: [
              Column(
                children: [
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  SendButton(postCreatorEmail: widget.user),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  ),
)

    ),
    );
        
    
    
    
  }
}