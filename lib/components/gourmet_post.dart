import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uridachi/components/comment.dart';
import 'package:uridachi/components/comment_button.dart';
import 'package:uridachi/components/delete_button.dart';
import 'package:uridachi/components/like_button.dart';
import 'package:uridachi/screen/coment_screen.dart';
import 'package:clay_containers/clay_containers.dart';



//where our posts are posted
class GourmetPost extends StatefulWidget {
    final String description;
    final String user;
    final String time;
    final String postId;
    final List<String> likes;
    final List<String> imageUrls;




  const GourmetPost({
    super.key,
    required this.description,
    required this.user,
    required this.time,
    required this.postId,
    required this.likes,
    required this.imageUrls,
 
});

  @override
  State<GourmetPost> createState() => _GourmetPostState();
}

class _GourmetPostState extends State<GourmetPost> {
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




  @override
  Widget build(BuildContext context) {
    Color baseColor = Color.fromARGB(255, 255, 255, 255);


    return Padding(
        padding: const EdgeInsets.only(top: 25, left: 25, right: 25),      
        child: ClayContainer(
          color: baseColor,
          height: null, // Remove fixed height
          borderRadius: 20,
          depth: 50, // Adjust depth to control shadow intensity
          spread: 5, // Adjust spread to control the size of the shadow



          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  
                  
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                  
                   Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
            Container(
                  
                  width: MediaQuery.of(context).size.width * 0.65, // Set the width to 80% of the screen width
                  child: Text(
            widget.description,
            style: TextStyle(fontSize: 20),
            maxLines: null, // Allow for any number of lines
                  ),
                  
                  ),
                  
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
                  
                const SizedBox(height: 20,),
                  
                  
                if (widget.imageUrls.isNotEmpty)
            Container(
                  height: 200, 
                  // Set a fixed height for the container
                  child: ListView.builder(
            scrollDirection: Axis.horizontal, // Make the list view scrollable horizontally
            itemCount: widget.imageUrls.length, // The number of items in the list
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0), // Add some spacing between images
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8), // Optional: Clip the images with a border radius
                  child: Image.network(
                    widget.imageUrls[index], // Load the image from the URL
                    width: 200, // Set a fixed width for each image
                    fit: BoxFit.cover, // Cover the bounds of the container
                  ),
                ),
              );
            },
                  ),
            ),
                  
                  const SizedBox(height: 25), 
                  
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
                    
                  
                      ],
                    ),
                  
                  
                    const SizedBox(width: 10,),
                  
                  
                    
                    
                  
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