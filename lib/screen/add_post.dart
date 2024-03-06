import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:uridachi/methods/firestore_methods.dart';


import 'package:uridachi/utils/utils.dart';
import 'package:uuid/uuid.dart';


class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {


  final currentUser = FirebaseAuth.instance.currentUser!;
  final TextEditingController _descriptionController = TextEditingController();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  List<File> selectedImages = [];
  final picker = ImagePicker();


  List<Uint8List>? _files;


  void showSnackBar(String message, BuildContext context) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}


  void postImage (
    String uid,
    String username,
  ) async {
    
    //이 이미지들 다 store 하는 방법 터득해야함
    try {
      String res = await FirestoreMethods().uploadPost(_descriptionController.text, selectedImages, uid, username);

      if (res == "success") {
        showSnackBar('Posted!', context);
      } else {
        showSnackBar(res, context);
      }

    } catch(e) {
      showSnackBar(e.toString(), context);

    }

}

  _selectImage(BuildContext context) async {
  // Show dialog to choose the image
  showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: const Text("Choose your image"),
        children: [
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Select a photo'),
            onPressed: () async {
              // Close the dialog
              Navigator.of(context).pop();
              // Call pickImages to get the list of selected images
              List<Uint8List> images = await pickImages(ImageSource.gallery);
              // Update the state with the new images
              setState(() {
                _files = images;
              });
            },
          ),
        ],
      );
    },
  );
}


Future<Map<String, dynamic>?> fetchUserData(String uid) async {
  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    if (userDoc.exists) {
      return userDoc.data() as Map<String, dynamic>?;
    }
    return null;
  } catch (e) {
    print("Error fetching user data: $e");
    return null;
  }
}


Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {
    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if(isPost) {
      String id = const Uuid().v1();
      ref.child(id);
    }

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }


Future<void> createPost() async {
  if (_descriptionController.text.isNotEmpty) {
    // Ensure the user is logged in
    if (currentUser != null) {
      try {
        // Retrieve current user's UID
        final String uid = currentUser.uid;
        
        // Use email or a placeholder if not available
        final String userEmail = currentUser.email ?? "No email";

        List<String> imageUrls = [];
        for (var image in selectedImages) {
          final Uint8List imageData = await image.readAsBytes();
          String imageUrl = await uploadImageToStorage('posts', imageData, true);
          imageUrls.add(imageUrl);
        }

        Map<String, dynamic> postData = {
          'description': _descriptionController.text,
          'uid': uid,
          'email': userEmail, // Here we're using the user's email
          'imageUrls': imageUrls,
          'datePublished': FieldValue.serverTimestamp(),
          'likes': [],
        };

        await FirebaseFirestore.instance.collection("Social Posts").add(postData);

        showSnackBar("Posted successfully!", context);
        _descriptionController.clear();
        setState(() {
          selectedImages.clear();
        });

      } catch (e) {
        showSnackBar(e.toString(), context);
      }
    } else {
      showSnackBar("User not logged in.", context);
    }
  } else {
    showSnackBar("Please enter a description.", context);
  }
}




@override
void dispose() {
  super.dispose();
  _descriptionController.dispose();
}


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Add Post"),
        actions: [
          TextButton(
              onPressed: createPost,

              child: const Text(
                "Post",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //post details
                  
                    
            
            
                          //여기다가 쓰는게 밑에 listview로 나와야함
                     
                      
            
                    
            
                    const Divider(),
            
                   
                  ],
                ),
            
                 SizedBox(
                      height: 50,
                    ),
            
            
            
            
                 Container(
                   child: Column(
                     children: [
                       SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                hintText: "Write your content..",
                                border: InputBorder.none,
                              ),
                              maxLines: 8,
                            ),
                          ),
                     ],
                   ),
                 ),
            
            
               
            
            
            
            
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
            
                   
            
                    
             SizedBox(
                      height: 20,
                    ),
            
                    
            
            
                    ElevatedButton(
			style: ButtonStyle(
				backgroundColor: MaterialStateProperty.all(Colors.green)),
			child: const Text('Select Image from Gallery and Camera'),
			onPressed: () {
				getImages();
			},
			),


      SizedBox(
                      height: 10,
                    ),
            

      Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: 300, // Specify a fixed height for the GridView container
          child: GridView.builder(
            itemCount: selectedImages.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        // Specify the space between the items
        crossAxisSpacing: 4, // Horizontal space
        mainAxisSpacing: 4, // Vertical space
            ),
            itemBuilder: (BuildContext context, int index) {
        // Wrap the Image with a Container to apply borderRadius and margin
        return Container(
          decoration: BoxDecoration(
            // Apply borderRadius to each image
            borderRadius: BorderRadius.circular(8),
            // Optional: Add a box shadow or border here if you like
          ),
          clipBehavior: Clip.antiAlias, // Clip the image to the borderRadius
          child: Image.file(
            selectedImages[index],
            fit: BoxFit.cover,
          ),
        );
            },
          ),
        ),
      ),

			
            
            
            
            
            

                 
            
            
            
            
            
                  ],
                ),
            
            
            
                
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future getImages() async {
	final pickedFile = await picker.pickMultiImage(
		imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
	List<XFile> xfilePick = pickedFile;

	setState(
	() {
		if (xfilePick.isNotEmpty) {
		for (var i = 0; i < xfilePick.length; i++) {
			selectedImages.add(File(xfilePick[i].path));
		}
		} else {
		ScaffoldMessenger.of(context).showSnackBar(
			const SnackBar(content: Text('Nothing is selected')));
		}
	},
	);
}


}
