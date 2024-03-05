import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uridachi/components/comment_button.dart';
import 'package:uridachi/components/delete_button.dart';
import 'package:uridachi/components/like_button.dart';
import 'package:uridachi/helper/helper_methods.dart';
import 'package:uridachi/components/comment.dart';


class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;



  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.time,
    required this.postId,
    required this.likes,

    });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {

  //getting the user from firebase
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);

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
        'Likes' : FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes' : FieldValue.arrayRemove([currentUser.email])
      });

    }


  }




  void addComment (String commentText) {
    //saving to firestore under "comments section"
    FirebaseFirestore.instance
    .collection("User Posts")
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
            collection("User Posts")
            .doc(widget.postId)
            .collection("comment").get();

            for (var doc in commentDocs.docs) {
              await FirebaseFirestore.instance.collection("User Posts")
              .doc(widget.postId)
              .collection("comment")
              .doc(doc.id)
              .delete();
            }


            //delete post
            FirebaseFirestore.instance.collection("User Posts").doc(widget.postId)
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200], 
        borderRadius: BorderRadius.circular(20),

      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      
      
      
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              
                  Text(widget.message),
              
                  const SizedBox(height: 10,),
                  Row(
                children: [
                  Text(
                    widget.user,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  Text(
                    " . ",
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  Text(
                    widget.time,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
                ],
              ),

              if (widget.user == currentUser.email) 
              DeleteButton(onTap: deletePost)

            ],
          ),

          const SizedBox(height: 10,),


          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [

                  //like
                  LikeButton(
                    isLiked: isLiked, 
                    onTap: toggleLike,
                  ),
              
                  const SizedBox(height: 5,),
              
                  Text(
                    widget.likes.length.toString(),
                    style: const TextStyle(color: Colors.grey,),
                    
                    ),
                ],
              ),

              const SizedBox(width: 10), 
              //comment
              Column(
                children: [

                  //like
                 CommentButton(onTap: showCommentDialog),
              
                  const SizedBox(height: 5,),


              
                  const Text(
                    '0',
                    style: TextStyle(color: Colors.grey,),
                    
                    ),
                ],
              ),
            ],
          ),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore
            .instance.collection("User Posts")
            .doc(widget.postId)
            .collection("comment")
            .orderBy("CommentTime", descending: true)
            .snapshots(),

            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  final commentData = doc.data() as Map<String, dynamic>;

                  return Comment(
                    text: commentData["CommentText"],
                    user: commentData["CommentedBy"],
                    time: formatDate(commentData["CommentTime"]),
                  );
                }).toList(),
              );

            },
            
            ),

          const SizedBox(height: 20,),




        ],
      ),






    );
  }
}