import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:login_page/error_dialog.dart';
import 'package:login_page/home_screen.dart';
import 'package:login_page/reusable_widget.dart';
import 'package:login_page/signup_page.dart';
import 'package:login_page/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loading_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  List images = ["googleicon.png", "twittericon.png", "fbicon.png"];
  String selectedCountry = ''; // Track the selected country

  formValidation() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      loginNow();
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
                message: "pleas fill all the fields.", title: "Error");
          });
    }
  }

  loginNow() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(message: "Checking credentials");
        });

    User? currentUser;
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim())
        .then((auth) {
      currentUser = auth.user!;
    }).catchError((e) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(message: e.message.toString(), title: "Error");
          });
    });
    if (currentUser != null) {
      readDataAndSetDataLocally(currentUser!).then((value) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WelcomePage()),
        );
      });
    }
  }

  Future readDataAndSetDataLocally(User currentUser) async {
    await FirebaseFirestore.instance
        .collection("travelers")
        .doc(currentUser.uid)
        .get()
        .then((snapShot) async {
      SharedPreferences? preferences = await SharedPreferences.getInstance();
      await preferences.setString("uid", currentUser.uid);
      await preferences.setString("email", _emailController.text.trim());
      await preferences.setString("uName", snapShot.data()!['userName']);
      await preferences.setString("photoURL", snapShot.data()!['imgUrl']);
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
            width: w,
            height: h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 187, 235, 205),
                    Color.fromARGB(255, 86, 105, 94),
                  ]),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: w,
                      height: h * 0.25,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        image: DecorationImage(
                          image: AssetImage('img/loginimg.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter UserName", Icons.person_outlined,
                        false, _emailController),
                    SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Password", Icons.lock_outline,
                        true, _passwordController),
                    SizedBox(
                      height: 20,
                    ),
                    // SignInSignUpButton(context, true, () {
                    //   FirebaseAuth.instance
                    //       .signInWithEmailAndPassword(
                    //           email: _emailController.text,
                    //           password: _passwordController.text)
                    //       .then((value) {
                    //     print("succefully login");
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => const WelcomePage()),
                    //     );
                    //   }).catchError((e) {
                    //     print(e);
                    //   });
                    // }),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          formValidation();
                          loginNow();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          textStyle: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Text('Sign-In'),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Or login via",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 15, 14, 14)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
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
                                radius:
                                    15, // Adjusted radius to reduce the size
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    AssetImage("img/${images[index]}"),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    signUpOption(),
                  ],
                ),
              ),
            )));
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignupPage()),
            );
          },
          child: Text(
            "Sign Up",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
