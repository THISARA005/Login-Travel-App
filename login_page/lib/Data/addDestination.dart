import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class AddDestination extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<AddDestination> {
  late File _selectedImage;
  String _imageUrl = '';

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
        await ref.putFile(_selectedImage);
        String imageUrl = await ref.getDownloadURL();
        setState(() {
          _imageUrl = imageUrl;
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> _saveImageUrlToFirestore() async {
    if (_imageUrl.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('your_collection').add({
          'image_url': _imageUrl,
        });
        print('Image URL saved to Firestore');
      } catch (e) {
        print('Error saving image URL to Firestore: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _selectedImage != null
                ? Image.file(
                    _selectedImage,
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
            ElevatedButton(
              onPressed: () {
                _uploadImage().then((_) {
                  _saveImageUrlToFirestore();
                });
              },
              child: Text('Upload and Save'),
            ),
          ],
        ),
      ),
    );
  }
}
