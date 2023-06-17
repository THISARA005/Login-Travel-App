import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiple_image_picker/multiple_image_picker.dart';
import 'package:multiple_images_picker/multiple_images_picker.dart';

class AddDestination extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<AddDestination> {
  List<File> _selectedImages = [];
  List<String> _imageUrls = [];
  TextEditingController _destNameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  String? _selectedRating;
  TextEditingController _reviewsController = TextEditingController();
  List<String> _ratingList = ['1', '2', '3', '4', '5'];

  Future<void> _selectImages() async {
    List<Asset> resultList = [];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
      );
    } catch (e) {
      print('Error selecting images: $e');
    }

    if (resultList.isNotEmpty) {
      List<File> images = [];
      List<String> urls = [];

      for (var asset in resultList) {
        try {
          File file = await assetToFile(asset);
          images.add(file);
          urls.add(await uploadImageToFirebase(file));
        } catch (e) {
          print('Error uploading image: $e');
        }
      }

      setState(() {
        _selectedImages = images;
        _imageUrls = urls;
      });
    }
  }

  Future<File> assetToFile(Asset asset) async {
    final byteData = await asset.getByteData();
    final file = File('${(await getTemporaryDirectory()).path}/${asset.name}');
    await file.writeAsBytes(byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    ));
    return file;
  }

  Future<String> uploadImageToFirebase(File image) async {
    try {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/$imageName.jpg');
      await ref.putFile(image);
      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<void> _saveDataToFirestore() async {
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
          'imageUrls': _imageUrls,
        });
        print('Data saved to Firestore');
        _showNotification('Data saved to Firestore');
      } catch (e) {
        print('Error saving data to Firestore: $e');
        _showNotification('Failed to save data to Firestore');
      }
    } else {
      _showNotification('Please fill all the required fields');
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
        title: Text('Add Destination'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _selectedImages.isNotEmpty
                  ? Column(
                      children: [
                        for (var image in _selectedImages)
                          Image.file(
                            image,
                            width: 200,
                            height: 200,
                          ),
                      ],
                    )
                  : Text('No Images Selected'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectImages,
                child: Text('Select Images'),
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
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedRating,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRating = newValue;
                  });
                },
                decoration: InputDecoration(
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
                decoration: InputDecoration(
                  labelText: 'Reviews',
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _saveDataToFirestore();
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
