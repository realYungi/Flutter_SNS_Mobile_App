import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';


import 'package:uridachi/utils/utils.dart';


class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {


  final TextEditingController _descriptionController = TextEditingController();



  List<File> selectedImages = [];
  final picker = ImagePicker();


  List<Uint8List>? _files;

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




  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Add Post"),
        actions: [
          TextButton(
              onPressed: () {},
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
                    CircleAvatar(
                      radius: 32, // Adjust the radius to fit your design
                      backgroundColor: const Color.fromARGB(255, 182, 182, 182), // Choose a background color
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                          size: 64, // Adjust the size of the icon as needed
                      ),
                    ),
            
                    
            
            
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
