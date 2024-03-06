import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> _uploadImage(String childName, Uint8List file, String email) async {
    String id = Uuid().v1();
    String filePath = '$childName/$email/$id';
    Reference ref = _storage.ref().child(filePath);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    return await snap.ref.getDownloadURL();
  }

  Future<List<String>> uploadMultipleImages(List<Uint8List> files, String childName) async {
    List<String> imageUrls = [];
    String email = _auth.currentUser!.email!.replaceAll('@', '_').replaceAll('.', '_');
    for (Uint8List file in files) {
      String downloadUrl = await _uploadImage(childName, file, email);
      imageUrls.add(downloadUrl);
    }
    return imageUrls;
  }
}
