import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_page/error_dialog.dart';
import 'package:login_page/home_screen.dart';
import 'package:login_page/login_page.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:login_page/reusable_widget.dart';
import 'package:login_page/welcome_page.dart';

import 'loading_dialog.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final ImagePicker _picker = ImagePicker();
  PickedFile? _imageFile;
  String? selectedAgeRange;
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  // Track the selected country

  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile Photo",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.camera),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: Text("Camera"),
              ),
              TextButton.icon(
                icon: Icon(Icons.image),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: Text("Gallery"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Widget imageProfile(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 115,
            left: 15,
            child: CircleAvatar(
              radius: 60.0, // Change the radius to adjust the size
              backgroundImage: _imageFile == null
                  ? AssetImage('img/profilepic.png')
                  : FileImage(File(_imageFile!.path)) as ImageProvider,
            ),
          ),
          Positioned(
            top: 165, // Change the top position
            left: 85, // Change the right position
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return bottomSheet(
                        context); // Pass the context to the bottomSheet function
                  },
                );
              },
              child: Icon(Icons.camera_alt,
                  color: Colors.teal, size: 48), // Change the size of the Icon
            ),
          ),
        ],
      ),
    );
  }

  // Future<void> formValidation() async {
  //   if (_imageFile == null) {
  //     showDialog(
  //         context: context,
  //         builder: (c) {
  //           return ErrorDialog(
  //             message: "Please select a profile picture",
  //             title: 'Error message',
  //           );
  //         });
  //   } else {
  //     Navigator.pushNamed(context, '/homePage');
  //   }
  // }

  Future<void> formValidation1() async {
    final form = _formKey.currentState;

    if (_imageFile == null) {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: "Please select a profile picture",
            title: 'Error message',
          );
        },
      );
    } else {
      if (_passwordController.text == _confirmPasswordController.text) {
        if (_confirmPasswordController.text.isNotEmpty &&
            _emailController.text.isNotEmpty &&
            _userNameController.text.isNotEmpty &&
            _phoneNumberController.text.isNotEmpty) {
          showDialog(
              context: context,
              builder: (c) {
                return LoadingDialog(message: "Creating account");
              });
        } else {
          showDialog(
              context: context,
              builder: (c) {
                return ErrorDialog(
                  message: "Please fill all the fields for the sign up",
                  title: 'Error message',
                );
              });
        }
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Passwords do not match",
                title: 'Error message',
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List images = ["googleicon.png", "twittericon.png", "fbicon.png"];

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 187, 235, 205),
                Color.fromARGB(255, 86, 105, 94),
              ]),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Container(
                  width: w,
                  height: h * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: AssetImage('img/createaccount.png'),
                      fit: BoxFit.contain, // or BoxFit.scaleDown
                    ),
                  ),
                  child: Align(
                    alignment:
                        Alignment.bottomLeft, // Change the alignment as needed
                    child: imageProfile(context),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(),
                  margin: const EdgeInsets.only(left: 20, top: 20),
                  width: w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 1,
                            vertical: 0), // Adjust the padding values as needed
                        child: Text(
                          "Let's start your journey with us...",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      reusableTextField("Enter UserName", Icons.person_outlined,
                          false, _userNameController),
                      SizedBox(
                        height: 20,
                      ),
                      reusableTextField(
                          "Enter email", Icons.email, false, _emailController),
                      SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Enter Password", Icons.lock, true,
                          _passwordController),
                      SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Confirm your password", Icons.lock,
                          true, _confirmPasswordController),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: w * 0.9,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(4, 67, 80, 80),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Age',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 214, 212, 212)),
                            ),
                            value: selectedAgeRange,
                            items: <String>[
                              "18-",
                              '18-25',
                              '26-35',
                              '36-45',
                              '46-55',
                              '56+',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedAgeRange = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: w * 0.9,
                  height: 45,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 10, 15, 0),
                    child: IntlPhoneField(
                      controller: _phoneNumberController,
                      initialCountryCode: 'SL',
                      onChanged: (phone) {
                        print(phone.completeNumber);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      formValidation1();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      textStyle: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text('Sign-Up'),
                  ),
                ),
                // SignInSignUpButton(context, false, () {
                //   FirebaseAuth.instance
                //       .createUserWithEmailAndPassword(
                //           email: _emailController.text,
                //           password: _passwordController.text)
                //       .then((value) {
                //     print("account created");
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const LoginPage()),
                //     );
                //   }).onError((error, stackTrace) {
                //     print("error ${error.toString()}");
                //   });
                // }),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Or login via",
                      style: TextStyle(
                          fontSize: 15, color: Color.fromARGB(255, 15, 14, 14)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Wrap(
                  children: List<Widget>.generate(
                    3,
                    (int index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          radius: 20, // Adjusted radius to reduce the size
                          backgroundColor: Colors.grey[500],
                          child: CircleAvatar(
                            radius: 15, // Adjusted radius to reduce the size
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage("img/${images[index]}"),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          child: Text(
                            "Login here",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
