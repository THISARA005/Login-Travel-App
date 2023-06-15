import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDestination extends StatefulWidget {
  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<AddDestination> {
  late File _selectedImage;
  late String _imageUrl;
  String _textInput1 = '';
  String _textInput2 = '';
  String _textInput3 = '';
  late int _selectedNumber;

  final List<int> _numbers = [1, 2, 3, 4, 5];

  Future<void> _uploadImage() async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(_selectedImage);
      String imageUrl = await ref.getDownloadURL();
      setState(() {
        _imageUrl = imageUrl;
      });
    } catch (e) {
      // Handle image upload error
      print(e.toString());
    }
  }

  Future<void> _saveDataToFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('your_collection').add({
        'image_url': _imageUrl,
        'text_input1': _textInput1,
        'text_input2': _textInput2,
        'text_input3': _textInput3,
        'selected_number': _selectedNumber,
      });
      // Data saved successfully
      // Perform any additional actions if needed
    } catch (e) {
      // Handle Firestore save error
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePreview(),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Select and set the image file
                  // You can use a plugin like image_picker to handle image selection
                  setState(() {
                    // _selectedImage = selectedImage;
                    // Replace the above line with your image selection logic
                  });
                },
                child: Text('Select Image'),
              ),
              SizedBox(height: 16.0),
              Text('Text Input 1'),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _textInput1 = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Text('Text Input 2'),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _textInput2 = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Text('Text Input 3'),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _textInput3 = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Text('Select a number'),
              DropdownButton<int>(
                value: _selectedNumber,
                items: _numbers.map((int number) {
                  return DropdownMenuItem<int>(
                    value: number,
                    child: Text(number.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedNumber = newValue!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_selectedImage != null &&
                      _textInput1.isNotEmpty &&
                      _textInput2.isNotEmpty &&
                      _textInput3.isNotEmpty &&
                      _selectedNumber != null) {
                    _uploadImage().then((_) {
                      _saveDataToFirestore();
                    });
                  } else {
                    // Show validation error message
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content:
                            Text('Please fill all fields and select an image.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_selectedImage != null) {
      return Container(
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(_selectedImage),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Text('No Image Selected');
    }
  }
}
