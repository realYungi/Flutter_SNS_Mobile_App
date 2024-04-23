import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uridachi/components/comment.dart';
import 'package:uridachi/components/comment_button.dart';
import 'package:uridachi/components/delete_button.dart';
import 'package:uridachi/components/like_button.dart';
import 'package:uridachi/components/send_button.dart';
import 'package:uridachi/pages/chat_view_page.dart';
import 'package:uridachi/screen/coment_screen.dart';
import 'package:clay_containers/clay_containers.dart';



//where our posts are posted
class GourmetText extends StatefulWidget {
    final String titleofpost;
    final String content;
    final String user;
    final String time;
    final String postId;
    final List<String> likes;
    final double rating;
    final String location;

  
  const GourmetText({
    super.key,
    required this.titleofpost,
    required this.content,
    required this.user,
    required this.time,
    required this.postId,
    required this.likes,
    required this.rating,
    required this.location,
 
});

  @override
  State<GourmetText> createState() => _GourmetTextState();
}

class _GourmetTextState extends State<GourmetText> {
  late List<String> likes;
  bool isLiked = false;
  final currentUser = FirebaseAuth.instance.currentUser!;

  final _commentTextController = TextEditingController();

  @override
  void initState () {
    super.initState();
    likes = List.from(widget.likes); // Initialize local likes list
    isLiked = likes.contains(currentUser.email);
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

    DocumentReference postRef = FirebaseFirestore.instance.collection('Gourmet Posts').doc(widget.postId);

    if (isLiked) {
      postRef.update({'Likes': FieldValue.arrayUnion([userEmail])});
    } else {
      postRef.update({'Likes': FieldValue.arrayRemove([userEmail])});
    }
  }


  void addComment (String commentText) {
    //saving to firestore under "comments section"
    FirebaseFirestore.instance
    .collection("Gourmet Posts")
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
            collection("Gourmet Posts")
            .doc(widget.postId)
            .collection("comment").get();

            for (var doc in commentDocs.docs) {
              await FirebaseFirestore.instance.collection("Gourmet Posts")
              .doc(widget.postId)
              .collection("comment")
              .doc(doc.id)
              .delete();
            }


            //delete post
            FirebaseFirestore.instance.collection("Gourmet Posts").doc(widget.postId)
            .delete().then((value) => print("Post Deleted"))
            .catchError((error) => print("Failed to Delete : $error"));


            Navigator.pop(context);



          }, child: const Text("Delete")),
        ],
      )
    );


  }


  Future<Map<String, dynamic>?> fetchUserDetailsByEmail(String userEmail) async {
  try {
    var usersCollection = FirebaseFirestore.instance.collection('Users');
    var querySnapshot = await usersCollection.where('email', isEqualTo: userEmail).limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      // Assuming 'username' and 'uid' are fields in your user documents
      return querySnapshot.docs.first.data() as Map<String, dynamic>?;
    } else {
      return null; // User not found
    }
  } catch (e) {
    print("Error fetching user details: $e");
    return null;
  }
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                                      const SizedBox(height: 10), 


                         

          
                    
                    const SizedBox(height: 25), 
                    
                    
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
          
                    children: [
                      
                    
                     Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          
                
          
                   
          
          
                    const SizedBox(height: 5,),
               
              Container(
                    
                    width: MediaQuery.of(context).size.width * 0.65, // Set the width to 80% of the screen width
                    child: Text(
              widget.titleofpost,
              style: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 0, 0, 0)),
              maxLines: null, // Allow for any number of lines
                    ),
                    
                    ),
                    
                    const SizedBox(height: 10,),
          
          
          
          
                  
          
                    
              ],
                    ),
                    
                    
                      if (widget.user == currentUser.email) 
                      DeleteButton(onTap: deletePost)
                    
                    ],
                  ),
                    
                  const SizedBox(height: 5,),
                    
                    
     
          
          
                    Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.location, // Display location
                style: TextStyle(fontSize: 13, color: const Color.fromARGB(255, 201, 201, 201)),
              ),
            ),
          
                     
          
          
                 Padding(
  padding: const EdgeInsets.only(top: 8.0),
  child: Row(
    children: [
      Icon(Icons.star, color: Colors.amber),
      Text('${widget.rating.toString()} / 5'), // Assuming rating is passed as a double
    ],
  ),
),

                              const SizedBox(height: 15), 
          
                    
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


                      const SizedBox(width: 30,),

                      Column(
                        children: [

                          
                    
                          //like
                          LikeButton(
                            isLiked: isLiked, 
                            onTap: toggleLike,
                          ),
                      
                          
                      
                    
                        ],
                      ),
                    
                    
                      const SizedBox(width: 10,),

                      Column(
                        children: [
                         SendButton(postCreatorEmail: widget.user),
                        ],
                      ),
          
                      
                    
                    
                      
                      
                    
                      //comment
                 
                    ],
                  ),
                    
                
                    
                    
                    
                    
                    
                ],
              ),
            ),
              ),
        );
    
        
    
    
    
  }
}