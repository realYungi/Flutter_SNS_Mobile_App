import 'dart:typed_data';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uridachi/methods/storage_methods.dart';
import 'package:uridachi/models/post.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> imageUrls = [];

  //uploading post
  Future<String> uploadPost(
  String description,
  List<File> files,
  String uid,
  String username,
) async {
  String res = "some error occurred";
  try {
    List<String> imageUrls = [];
    for (var file in files) {
      String imageUrl = await StorageMethods().uploadImageToStorage('posts', await file.readAsBytes(), true);
      imageUrls.add(imageUrl);
    }

    String postId = const Uuid().v1();

    Post post = Post(
      description: description,
      uid: uid,
      username: username,
      postId: postId,
      datePublished: DateTime.now(),
      likes: [],
      photoUrls: imageUrls, // Adjusted for multiple images
    );

    await _firestore.collection('posts').doc(postId).set(post.toJson());
    res = "success";
  } catch (err) {
    res = err.toString();
  }
  return res;
}

}
