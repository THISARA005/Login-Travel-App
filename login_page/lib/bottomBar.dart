import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:login_page/Pages/chatScreen.dart';
import 'package:login_page/Pages/favouritesPage.dart';
import 'package:login_page/Pages/map.dart';
import 'package:login_page/Pages/profile.dart';
import 'package:login_page/Pages/startScreen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<NavBar> {
  final items = [
    const Icon(Icons.home),
    const Icon(Icons.location_on),
    const Icon(Icons.message),
    const Icon(Icons.favorite),
    const Icon(Icons.person),
  ];

  int index = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        items: items,
        onTap: (selectedIndex) {
          setState(() {
            index = selectedIndex;
          });
        },
        color: Color.fromARGB(255, 255, 255, 255),
        backgroundColor: Color.fromARGB(255, 86, 105, 94),
      ),
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
        child: getSelectedWidget(index: index),
      ),
    );
  }

  Widget getSelectedWidget({required int index}) {
    switch (index) {
      case 0:
        return StartScreen();
      case 1:
        return MapPage();
      case 2:
        return ChatScreen();
      case 3:
        return FavPage();
      case 4:
        return ProfilePage();
      default:
        return const Placeholder();
    }
  }
}
