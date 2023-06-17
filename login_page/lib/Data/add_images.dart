import 'dart:io' if (dart.library.html) 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddImage extends StatefulWidget {
  const AddImage({Key? key}) : super(key: key);

  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  bool uploading = false;
  double val = 0;
  CollectionReference imgRef =
      FirebaseFirestore.instance.collection('Destinations');
  List<XFile> _image = []; // List to store selected images
  FirebaseStorage ref = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Image'),
        actions: [
          ElevatedButton(
            child: Text("Save"),
            onPressed: () {
              // uploadImageToFirebase(context)
              //     .whenComplete(() => Navigator.pop(context));
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent:
                        200, // Set the maximum width for each grid item
                    mainAxisSpacing:
                        10, // Set the spacing between the items vertically
                    crossAxisSpacing:
                        10, // Set the spacing between the items horizontally
                  ),
                  itemCount:
                      _image.length + 1, // Set the total number of grid items
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Center(
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            !uploading ? chooseImage() : null;
                          },
                        ),
                      );
                    } else {
                      return Container(
                        margin: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: getImageProvider(_image[index - 1]),
                          ),
                        ),
                      );
                    }
                  },
                ),
                uploading
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              child: Text(
                                'Uploading...',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CircularProgressIndicator(
                              value: val,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.green),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider getImageProvider(XFile imageFile) {
    if (kIsWeb) {
      return NetworkImage(imageFile.path);
    } else {
      return FileImage(File(imageFile.path));
    }
  }

  chooseImage() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _image.addAll(pickedFiles.map((pickedFile) => XFile(pickedFile.path)));
      });
    } else {
      await retrieveLostData();
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await ImagePicker().getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(XFile(response.file!.path));
      });
    } else {
      print(response.file);
    }
  }

  Future uploadImageToFirebase(BuildContext context) async {
    int i = 1;
    if (_image.isNotEmpty) {
      try {
        for (var img in _image) {
          setState(() {
            uploading = true;
            val = i / _image.length;
          });
          String imageName = DateTime.now().millisecondsSinceEpoch.toString();
          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref()
              .child('Destinations/$imageName.jpg');
          await ref.putFile(File(img.path));
          String imageUrl = await ref.getDownloadURL();
          print(imageUrl);
          await imgRef.add({'image_url': imageUrl});
          i = i + 1;
        }
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
    imgRef = FirebaseFirestore.instance.collection('Destinations');
  }
}
