import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final List<dynamic> likes;   
  final List<String> photoUrls;
  


  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.likes,
    required this.photoUrls,

  });

  Map<String, dynamic> toJson() => {
    "description" : description,
    "uid" : uid,
    "username" : username,
    "postId" : postId,
    "datePublished": Timestamp.fromDate(datePublished),
    "likes" : likes,
    "photoUrls" : photoUrls,
  };


  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      username: snapshot['username'],
      uid: snapshot['uid'],
      description: snapshot['description'],
      postId: snapshot['postId'],
      datePublished: (snapshot['datePublished'] as Timestamp).toDate(),
      likes: snapshot['likes'],
      photoUrls: snapshot['photoUrls']
    );
  }



}