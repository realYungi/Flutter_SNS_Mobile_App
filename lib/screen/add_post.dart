import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:uridachi/components/custom_text_form_field.dart';
import 'package:uridachi/methods/storage_methods.dart';


import 'package:uridachi/utils/utils.dart';
import 'package:uuid/uuid.dart';


class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  double _rating = 3.0; // Default rating value


  final currentUser = FirebaseAuth.instance.currentUser!;
  final TextEditingController _titleofpostController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _placeSearchController = TextEditingController();

  List<File> selectedImages = [];
  final picker = ImagePicker();


  List<Uint8List>? _files;

  String? _selectedCategory;
  String? _selectedType;

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
    print(downloadUrl);
    return downloadUrl;
  }


Future<void> createPost() async {
  if (_titleofpostController.text.isNotEmpty && _auth.currentUser != null) {
    try {
      // Define a variable to hold image URLs
      List<String> imageUrls = [];

      // If the selectedType is "With Image", process and upload the images
      if (_selectedType == "With Image") {
        // Convert File images to Uint8List
        List<Uint8List> imageFiles = await Future.wait(selectedImages.map((file) => file.readAsBytes()).toList());
        // Upload images and get their URLs
        StorageMethods storageMethods = StorageMethods();
        imageUrls = await storageMethods.uploadMultipleImages(imageFiles, 'posts');
      }

      // Construct post data, conditionally include imageUrls based on selectedType
      Map<String, dynamic> postData = {
        'titleofpost': _titleofpostController.text,
        'content' : _contentController.text,
        'uid': _auth.currentUser!.uid,
        'email': _auth.currentUser!.email,
        'datePublished': FieldValue.serverTimestamp(),
        'likes': [],
        // Include image URLs only if there are any
        if (imageUrls.isNotEmpty) 'imageUrls': imageUrls,
      };

      // Save the post data to Firestore
      await FirebaseFirestore.instance.collection("Social Posts").add(postData);
      showSnackBar("Posted successfully!", context);

      // Reset state
      _titleofpostController.clear();
      setState(() {
        selectedImages.clear();
        _files = null; // Ensure any selected file previews are also cleared
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  } else {
    showSnackBar("Please enter a titleofpost and ensure you're logged in.", context);
  }
}



Future<void> createGourmet() async {
  if (_titleofpostController.text.isNotEmpty && _auth.currentUser != null && selectedImages.isNotEmpty) {
    try {
      StorageMethods storageMethods = StorageMethods();

      List<String> imageUrls = [];
      List<Uint8List> imageFiles = selectedImages.map((file) => File(file.path).readAsBytesSync()).toList();
      imageUrls = await storageMethods.uploadMultipleImages(imageFiles, 'gourmet_posts');

      // Construct post data, including the rating, image URLs, and location
      Map<String, dynamic> postData = {
        'titleofpost': _titleofpostController.text,
        'content' : _contentController.text,
        'uid': _auth.currentUser!.uid,
        'email': _auth.currentUser!.email,
        'imageUrls': imageUrls,
        'datePublished': FieldValue.serverTimestamp(),
        'likes': [],
        'rating': _rating,
        'location': _placeSearchController.text, // Save location from _placeSearchController
      };

      await FirebaseFirestore.instance.collection("Gourmet Posts").add(postData);
      showSnackBar("Posted successfully!", context);

      _titleofpostController.clear();
      setState(() {
        selectedImages.clear();
        _files = null;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  } else {
    showSnackBar("Please select at least one image for a Gourmet post.", context);
  }
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



@override
void dispose() {
  super.dispose();
  _titleofpostController.dispose();
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
      border: InputBorder.none, // Remove the underline
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

// This dropdown is now always visible when a category is selected
 // Check if a category is selected
  Container(
    decoration: BoxDecoration(
      color: Colors.grey[200], // Set the background color to a shade of gray.
      borderRadius: BorderRadius.circular(20), // Set the border radius.
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    margin: const EdgeInsets.only(top: 10, bottom: 10), // Add some margin at the top and bottom
    child: DropdownButtonFormField<String>(
      value: _selectedType,
      hint: Text("Select type"),
      decoration: InputDecoration(
        border: InputBorder.none, // Remove the underline
      ),
      items: ["Text Only", "With Image"].map((String type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedType = newValue;
        });
      },
    ),
  ),



SizedBox(
                      height: 20,
                    ),


// Inside your build method
Visibility(
  // Show the button if _selectedCategory is "Gourmet" and _selectedType is not "Text Only",
  // or if _selectedType is "With Image"
  visible: (_selectedCategory == "Gourmet" && _selectedType == "With Image") ||
           (_selectedCategory == "Social" && _selectedType == "With Image"),
  child: ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.green)
    ),
    child: const Text(
      'Select Image from Gallery and Camera',
      style: TextStyle(color: Colors.white),
    ),
    onPressed: () {
      getImages();
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
          width: MediaQuery.of(context).size.width * 0.7, 
          height: 40,// Consider using full width for true centering if needed.
          child: TextField(
            
            controller: _titleofpostController,
            decoration: const InputDecoration(
              hintText: "Write your Title..",
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

              if (_selectedCategory == "Gourmet") // Conditionally render the text "star"
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: RatingBar.builder(
  initialRating: _rating,
  minRating: 1,
  direction: Axis.horizontal,
  allowHalfRating: true,
  itemCount: 5,
  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
  itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
  onRatingUpdate: (rating) {
    setState(() {
      _rating = rating; // Update _rating with the new rating
    });
  },
),






                  ),
if (_selectedCategory == "Gourmet")
  Container(
    decoration: BoxDecoration(
      color: Colors.grey[200], // Set the background color to a shade of gray.
      borderRadius: BorderRadius.circular(20), // Set the border radius.
    ),
    padding: const EdgeInsets.all(8.0),
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4), // Match the margin as needed
    child: Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7, // Consider using full width for true centering if needed.
          child: CustomTextFormField(controller: _placeSearchController),
        ),
      ],
    ),
  ),
          
            
            SizedBox(height: 20,),
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
            controller: _contentController,
            decoration: const InputDecoration(
              hintText: "Write your Content..",
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

}
