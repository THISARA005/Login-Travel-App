import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

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
  bool _isLoading = false;
  LatLng? _selectedLocation;

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
        setState(() {
          _isLoading = true;
        });

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

        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print('Error uploading image: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveDataToFirestore() async {
    if (_imageUrl.isNotEmpty) {
      try {
        setState(() {
          _isLoading = true;
        });

        await FirebaseFirestore.instance.collection('Destination').add({
          'destName': _destNameController.text,
          'location': _locationController.text,
          'city': _cityController.text,
          'ratings': double.parse(_ratingsController.text),
          'reviews': _reviewsController.text,
          'image_url': _imageUrl,
          'latitude': _selectedLocation?.latitude,
          'longitude': _selectedLocation?.longitude,
        });

        await Future.delayed(Duration(seconds: 3));

        Fluttertoast.showToast(
          msg: 'Data saved to Firestore',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print('Error saving data to Firestore: $e');
        setState(() {
          _isLoading = false;
        });
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
              SizedBox(height: 20),
              Container(
                height: 200,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        37.7749, -122.4194), // Default location (San Francisco)
                    zoom: 12,
                  ),
                  onTap: (LatLng latLng) async {
                    setState(() {
                      _selectedLocation = latLng;
                    });

                    List<Placemark> placemarks = await placemarkFromCoordinates(
                      latLng.latitude,
                      latLng.longitude,
                    );

                    if (placemarks.isNotEmpty) {
                      Placemark placemark = placemarks[0];
                      String address = placemark.name ?? '';
                      _locationController.text = address;
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _ratingsController,
                decoration: InputDecoration(
                  labelText: 'Ratings',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 20),
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
              SizedBox(height: 20),
              _isLoading
                  ? SpinKitCircle(
                      color: Theme.of(context).primaryColor,
                      size: 50.0,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
