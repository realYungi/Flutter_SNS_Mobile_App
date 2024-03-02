import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

Future<List<Uint8List>> pickImages(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile>? _files = await _imagePicker.pickMultiImage();

  // Initialize an empty list of Uint8List to store the image data
  List<Uint8List> images = [];

  // Check if the user selected any files
  if (_files != null) {
    // Loop through all selected files
    for (XFile file in _files) {
      // Read each file as bytes and add to the images list
      Uint8List imageData = await file.readAsBytes();
      images.add(imageData);
    }
  } else {
    print("No images selected");
  }

  // Return the list of image data
  return images;
}

