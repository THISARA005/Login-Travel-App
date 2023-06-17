import 'dart:io' if (dart.library.html) 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddImage extends StatefulWidget {
  const AddImage({Key? key}) : super(key: key);

  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  List<XFile> _image = []; // List to store selected images

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Image'),
        actions: [ElevatedButton(child: Text("Save"), onPressed: () {})],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
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
                        chooseImage();
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
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image.add(pickedFile);
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
        _image.add(XFile(response.file!.path!));
      });
    } else {
      print(response.file);
    }
  }
}
