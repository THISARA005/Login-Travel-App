import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddDestination extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<AddDestination> {
  File? _selectedImage;
  String _imageUrl = '';
  TextEditingController _destNameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _ratingsController = TextEditingController();
  TextEditingController _reviewsController = TextEditingController();

  Future<void> _selectImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage != null) {
      try {
        String imageName = DateTime.now().millisecondsSinceEpoch.toString();
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images/$imageName.jpg');
        await ref.putFile(_selectedImage!);
        String imageUrl = await ref.getDownloadURL();
        setState(() {
          _imageUrl = imageUrl;
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> _saveDataToFirestore() async {
    if (_imageUrl.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('Destination').add({
          'destName': _destNameController.text,
          'location': _locationController.text,
          'city': _cityController.text,
          'ratings': int.parse(_ratingsController.text),
          'reviews': _reviewsController.text,
          'image_url': _imageUrl,
        });
        Fluttertoast.showToast(
          msg: 'Data saved to Firestore',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } catch (e) {
        print('Error saving data to Firestore: $e');
      }
    }
  }

  @override
  void dispose() {
    _destNameController.dispose();
    _locationController.dispose();
    _cityController.dispose();
    _ratingsController.dispose();
    _reviewsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Destination'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      width: 200,
                      height: 200,
                    )
                  : Text('No Image Selected'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectImage,
                child: Text('Select Image'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _destNameController,
                decoration: InputDecoration(
                  labelText: 'Destination Name',
                ),
              ),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                ),
              ),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                ),
              ),
              TextField(
                controller: _ratingsController,
                decoration: InputDecoration(
                  labelText: 'Ratings',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _reviewsController,
                decoration: InputDecoration(
                  labelText: 'Reviews',
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _uploadImage().then((_) {
                    _saveDataToFirestore();
                  });
                },
                child: Text('Upload and Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
