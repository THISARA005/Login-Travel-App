import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          const Icon(Icons.home),
          const Icon(Icons.map),
          const Icon(Icons.chat),
          const Icon(Icons.favorite),
          const Icon(Icons.person),
        ],
        onTap: (index) {
          print(index);
        },
        color: Color.fromARGB(255, 255, 255, 255),
        backgroundColor: Color.fromARGB(255, 86, 105, 94),
      ),
    );
  }
}
