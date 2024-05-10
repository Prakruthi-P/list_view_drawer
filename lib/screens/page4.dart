import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Page4 extends StatefulWidget {
  const Page4({super.key});

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Center(
            child: Text("Page4",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.grey,
          child: const Center(
            child: Text("Page4",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //call function
            _uploadImage( context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _uploadImage(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(

          title: const Text("Upload Image"),
          actions:<Widget>[
            //Image.file(image_path),
          ElevatedButton(
              onPressed:(){ _uploadFromGallery();},
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(20), // Add elevation
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(12)), // Add padding
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Change background color
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                overlayColor: MaterialStateProperty.all(Colors.green),
                minimumSize: MaterialStateProperty.all<Size>(const Size(double.infinity, 48)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image
                  ),
                  SizedBox(width: 10,),
                  Text("From Gallery",
                  style:TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  )
                  ),
                ],
              )
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
              onPressed:(){ _uploadFromCamera();},
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(20), // Add elevation
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(12)), // Add padding
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Change background color
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.blue.withOpacity(0.5); // Change hover color
                    }
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.blue.withOpacity(0.8); // Change splash color
                    }
                    return Colors.blue; // Default color
                  },
                ),
                minimumSize: MaterialStateProperty.all<Size>(const Size(double.infinity, 48)), // Set width to infinity
                // Add margin
                //padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 20)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_camera),
                  SizedBox(width: 10,),
                  Text("Take Picture ",
                      style:TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      )
                  ),
                ],
              )
          ),


        ]
      );
    },
    );
  }
  Future<void> _uploadFromGallery() async {
    try {
      final pickedImages = await ImagePicker().pickMultiImage();

      if (pickedImages != null) {
        // Iterate over picked images
        for (final image in pickedImages) {
          final bytes = await image.readAsBytes();
          final base64Image = base64Encode(bytes);

          // Upload image to server with base64 data
          await _uploadImageToServer(base64Image);
        }
      } else {
        // Handle user canceling image selection
      }
    } on Exception catch (e) {
      // Handle errors during image selection
    }
  }


  Future<void> _uploadFromCamera() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );

      if (pickedImage != null) {
        final bytes = await pickedImage.readAsBytes();
        final base64Image = base64Encode(bytes);

        // Upload image to server with base64 data
        await _uploadImageToServer(base64Image);
      } else {
        // Handle user canceling image selection
      }
    } on Exception catch (e) {
      // Handle errors during camera access
    }
  }
  Future<void> _uploadImageToServer(String base64Image) async {
    final url = Uri.parse('http://localhost/Image/insert_image.php'); // Replace with your API endpoint
    final response = await http.post(
      url,
      body: {
        'image': base64Image,
      },
    );

    if (response.statusCode == 200) {
      // Handle successful upload
      print('Image uploaded successfully');
    } else {
      // Handle upload errors
      print('Error uploading image: ${response.statusCode}');
    }
  }

}


