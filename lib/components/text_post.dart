import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Ensure you have the necessary imports for Firebase, ClayContainer, etc.

class TextPost extends StatefulWidget {
  final String description;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;

  const TextPost({
    super.key,
    required this.description,
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

  @override
  void initState() {
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

    DocumentReference postRef = FirebaseFirestore.instance.collection('Social Posts').doc(widget.postId);

    if (isLiked) {
      postRef.update({'Likes': FieldValue.arrayUnion([userEmail])});
    } else {
      postRef.update({'Likes': FieldValue.arrayRemove([userEmail])});
    }
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance.collection("Social Posts").doc(widget.postId).collection("comment").add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now(),
    });
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: const InputDecoration(hintText: "Write a comment"),
        ),
        actions: [
          TextButton(
            onPressed: () {
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

  @override
  Widget build(BuildContext context) {
    Color baseColor = Color.fromARGB(255, 255, 255, 255);

    return Padding(
      padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
      child: ClayContainer(
        color: baseColor,
        borderRadius: 20,
        depth: 50,
        spread: 5,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.description,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                widget.user,
                style: TextStyle(color: Colors.grey[400]),
              ),
              const SizedBox(height: 5),
              Text(
                widget.time,
                style: TextStyle(color: Colors.grey[400]),
              ),
              // Additional UI components (like buttons) similar to the original SocialPost
            ],
          ),
        ),
      ),
    );
  }
}
