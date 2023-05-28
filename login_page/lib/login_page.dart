import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
              width: w,
              height: h * 0.25,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('img/loginimg.png'),
                  fit: BoxFit.cover,
                ),
              )),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            margin: const EdgeInsets.only(left: 20, top: 20),
            width: w,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Let's Start your journey with us",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              Text(
                "Sign in to your account",
                style: TextStyle(fontSize: 20, color: Colors.grey[500]),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 7,
                      spreadRadius: 1,
                      offset: const Offset(1, 1),
                    )
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.grey[500],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 7,
                      spreadRadius: 1,
                      offset: const Offset(1, 1),
                    )
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixIcon: Icon(
                      Icons.password,
                      color: Colors.grey[500],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              )
            ]),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(child: Container()),
              Text(
                "Forgot your Password?",
                style: TextStyle(fontSize: 15, color: Colors.grey[500]),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Container(
              width: w * 0.5,
              height: h * 0.08,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                  image: AssetImage('img/signin.png'),
                  fit: BoxFit.cover,
                ),
              )),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Or login via",
                style: TextStyle(fontSize: 15, color: Colors.grey[500]),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, right: 0, top: 20),
                width: w * 0.5,
                height: h * 0.08,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(70),
                  image: DecorationImage(
                    image: AssetImage('img/fbicon.png'),
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 0,
                  top: 20,
                  right: 30,
                ),
                width: w * 0.2,
                height: h * 0.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                    image: AssetImage('img/gmailicon.png'),
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
