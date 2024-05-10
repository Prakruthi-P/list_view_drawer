import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class Page3 extends StatefulWidget {
  const Page3({Key? key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  late ScaffoldMessengerState scaffoldMessengerState; // Change to make it accessible

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scaffoldMessengerState = ScaffoldMessenger.of(context); // Update the assignment
  }

  void _showImageUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Upload Image"),
          content: Text("Do you want to upload an image?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Add your logic to handle image upload here
                _showImageUploadDialoge(context);
              },
              child: Text("Upload"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
  void _showImageUploadDialoge(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Upload Image"),
          content: Text("Select an option to upload an image:"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                _uploadFromGallery(context);
              },
              child: Text("Upload from Gallery",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              ),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(20), // Add elevation
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(12)), // Add padding
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
                minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 48)), // Set width to infinity
                // Add margin
                //padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 20)),
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                _takePicture(context);
              },
              child: Text("Take a Picture",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(20), // Add elevation
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(12)), // Add padding
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
                minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 48)), // Set width to infinity
                // Add margin
                // margin: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 20)),
              ),
            ),


          ],
        );
      },
    );
  }
  void _uploadFromGallery(BuildContext context) async {
    Navigator.of(context).pop(); // Close the dialog
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final bytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(bytes);

      // Send image data to the server
      final response = await http.post(
        Uri.parse('http://192.168.1.46/Image/insert_image.php'), // Replace with your PHP endpoint URL
        body: jsonEncode({
          'image': base64Image,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      // Check if the image was successfully uploaded
      if (response.statusCode == 200) {

        print("Image uploaded successfully");
      } else {

        print('Failed to upload image');
      }
    } else {
      print('No image selected');
    }
  }


  void _takePicture(BuildContext context) {
    Navigator.of(context).pop(); // Close the dialog
    // Add logic to take a picture (using camera)
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Center(
            child: Text(
              "Page3",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.tealAccent,
          child: Center(
            child: const Text(
              "Page3",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showImageUploadDialog(context);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }


}
