import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:uridachi/methods/storage_methods.dart';


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

  String? _selectedCategory;

  void showSnackBar(String message, BuildContext context) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
  if (_descriptionController.text.isNotEmpty && _auth.currentUser != null) {
    try {
      // Convert File images to Uint8List
      List<Uint8List> imageFiles = await Future.wait(selectedImages.map((file) => file.readAsBytes()).toList());

      // Upload images and get their URLs
      StorageMethods storageMethods = StorageMethods();
      List<String> imageUrls = await storageMethods.uploadMultipleImages(imageFiles, 'posts');

      // Construct post data
      Map<String, dynamic> postData = {
        'description': _descriptionController.text,
        'uid': _auth.currentUser!.uid,
        'email': _auth.currentUser!.email, // Using the user's email
        'imageUrls': imageUrls,
        'datePublished': FieldValue.serverTimestamp(),
        'likes': [],
      };

      // Save the post data to Firestore
      await FirebaseFirestore.instance.collection("Social Posts").add(postData);
      showSnackBar("Posted successfully!", context);

      // Reset state
      _descriptionController.clear();
      setState(() => selectedImages.clear());
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  } else {
    showSnackBar("Please enter a description and ensure you're logged in.", context);
  }
}

Future<void> createGourmet() async {
  if (_descriptionController.text.isNotEmpty && _auth.currentUser != null) {
    try {
      // Convert File images to Uint8List
      List<Uint8List> imageFiles = await Future.wait(selectedImages.map((file) => file.readAsBytes()).toList());

      // Upload images and get their URLs
      StorageMethods storageMethods = StorageMethods();
      List<String> imageUrls = await storageMethods.uploadMultipleImages(imageFiles, 'gourmet');

      // Construct post data
      Map<String, dynamic> postData = {
        'description': _descriptionController.text,
        'uid': _auth.currentUser!.uid,
        'email': _auth.currentUser!.email, // Using the user's email
        'imageUrls': imageUrls,
        'datePublished': FieldValue.serverTimestamp(),
        'likes': [],
      };

      // Save the post data to Firestore
      await FirebaseFirestore.instance.collection("Gourmet Posts").add(postData);
      showSnackBar("Posted successfully!", context);

      // Reset state
      _descriptionController.clear();
      setState(() => selectedImages.clear());
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  } else {
    showSnackBar("Please enter a description and ensure you're logged in.", context);
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
    title: const Text("Add Post"),
    backgroundColor: Colors.white,
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(4.0), // Height of the gradient line
      child: Container(
        height: 4.0, // Height of the gradient line
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4FD9B8), // Start color of the gradient
              Color(0xFFE3FFCD), // End color of the gradient
            ],
          ),
        ),
      ),
    ),
  ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              
              children: [
               
            
                


             Container(
  decoration: BoxDecoration(
    color: Colors.grey[200], // Set the background color to a shade of gray.
    borderRadius: BorderRadius.circular(20), // Set the border radius.
  ),
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
  margin: const EdgeInsets.only(top: 20, bottom: 10), // Add some margin at the top
  child: DropdownButtonFormField<String>(
    value: _selectedCategory,
    hint: Text("Select a category"),
    decoration: InputDecoration(
      // Remove the underline
      border: InputBorder.none,
      // Additional decorations can go here (e.g., filled, fillColor)
    ),
    items: ["Social", "Gourmet"].map((String category) {
      return DropdownMenuItem(
        value: category,
        child: Text(category),
      );
    }).toList(),
    onChanged: (newValue) {
      setState(() {
        _selectedCategory = newValue;
      });
    },
  ),
),

            SizedBox(
                      height: 20,
                    ),
            
            
            Container(
  decoration: BoxDecoration(
    color: Colors.grey[200], // Set the background color to a shade of gray.
    borderRadius: BorderRadius.circular(20), // Set the border radius.
  ),
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7, // Consider using full width for true centering if needed.
          child: TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: "Write your content..",
              border: InputBorder.none,
              // Centering the hint text as well.
            ),
            textAlign: TextAlign.center, // Centering the text that user enters.
            maxLines: 8,
          ),
        ),
      ],
    ),
  ),
),

               
            
            
            
            
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
            
                   
            
                    
             SizedBox(
                      height: 30,
                    ),
            
                    
            
            
                    ElevatedButton(
			style: ButtonStyle(
				backgroundColor: MaterialStateProperty.all(Colors.green)),
			child: const Text('Select Image from Gallery and Camera',style: TextStyle(color: Colors.white),),
			onPressed: () {
				getImages();
			},
			),


      SizedBox(
                      height: 10,
                    ),
            

      Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 200, // Specify a fixed height for the GridView container
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


     




			
            
             ElevatedButton(
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.green),
  ),
  child: const Text('Post', style: TextStyle(color: Colors.white),),
  onPressed: () {
    // Check the selected category and call the corresponding method
    if (_selectedCategory == 'Social') {
      createPost();
    } else if (_selectedCategory == 'Gourmet') {
      createGourmet();
    } else {
      // Optional: Show a snackbar message if no category is selected
      showSnackBar("Please select a category.", context);
    }
  },
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
