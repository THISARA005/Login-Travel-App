import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Container(
              width: w,
              height: h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 1, 62, 5),
                    Color.fromRGBO(99, 141, 93, 1),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: AssetImage('img/welcomeimg.jpeg'),
                  fit: BoxFit.cover, // or BoxFit.scaleDown
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/homePage');
                  },
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        // Set the desired background color here
                        child: Padding(
                          padding: EdgeInsets.all(
                              10), // Add additional padding if needed
                          child: Text(
                            'Get Started',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 40,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
