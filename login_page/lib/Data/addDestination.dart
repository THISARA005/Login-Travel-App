import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_page/Data/add_images.dart';

class AddDestination extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<AddDestination> {
  AddImage addImageState = AddImage();

  File? _selectedImage;
  String _imageUrl = '';
  TextEditingController _destNameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  String? _selectedRating;
  TextEditingController _reviewsController = TextEditingController();
  List<String> _ratingList = [
    '1',
    '1.5',
    '2',
    '2.5',
    '3',
    '3.5',
    '4',
    '4.5',
    '5'
  ];

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
      String destName = _destNameController.text.trim();
      String location = _locationController.text.trim();
      String city = _cityController.text.trim();
      String reviews = _reviewsController.text.trim();

      if (destName.isNotEmpty &&
          city.isNotEmpty &&
          _selectedRating != null &&
          reviews.isNotEmpty) {
        try {
          await FirebaseFirestore.instance.collection('Destination').add({
            'destName': destName,
            'location': location,
            'city': city,
            'ratings': int.parse(_selectedRating!),
            'reviews': reviews,
            'image_url': _imageUrl,
          });
          print('Data saved to Firestore');
          _showNotification('Data saved to Firestore');
        } catch (e) {
          print('Error saving data to Firestore: $e');
          _showNotification('Failed to save data to Firestore');
        }
      } else {
        String errorMessage = '';

        if (destName.isEmpty) {
          errorMessage += 'Destination Name is required. ';
        }

        if (city.isEmpty) {
          errorMessage += 'City is required. ';
        }

        if (_selectedRating == null) {
          errorMessage += 'Please select a Rating. ';
        }

        if (reviews.isEmpty) {
          errorMessage += 'Reviews is required. ';
        }
        _showNotification(errorMessage);
      }
    }
  }

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    _destNameController.dispose();
    _locationController.dispose();
    _cityController.dispose();
    _reviewsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Destination'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      width: 200,
                      height: 200,
                    )
                  : const Text('No Image Selected'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectImage,
                child: const Text('Select Image'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _destNameController,
                decoration: const InputDecoration(
                  labelText: 'Destination Name',
                ),
              ),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                ),
              ),
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedRating,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRating = newValue;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Ratings',
                ),
                items: _ratingList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextField(
                controller: _reviewsController,
                decoration: const InputDecoration(
                  labelText: 'Reviews',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddImage()));
                  },
                  child: const Text("Pick images for the gallery")),
              ElevatedButton(
                onPressed: () {
                  _uploadImage().then((_) {
                    _saveDataToFirestore();
                  });
                },
                child: const Text('Upload and Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
