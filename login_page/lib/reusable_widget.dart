import 'package:flutter/material.dart';
import 'dart:io';

Container reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return Container(
    child: TextField(
      controller: controller,
      obscureText: isPasswordType,
      enableSuggestions: isPasswordType,
      autocorrect: isPasswordType,
      cursorColor: Colors.black,
      style: TextStyle(
        color: Colors.white.withOpacity(0.9),
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.white70,
        ),
        labelText: text,
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.9),
        ),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
        ),
      ),
      keyboardType: isPasswordType
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
    ),
  );
}

Container SignInSignUpButton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.8,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(90),
      color: Colors.white,
    ),
    child: ElevatedButton(
      onPressed: onTap(),
      child: Text(
        isLogin ? "Login" : "Sign Up",
        style: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.black26;
          }
          return Colors.white;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    ),
  );
}
// Container(
                      //   width: w *
                      //       0.9, // Update the width value according to your desired size
                      //   height: 40,
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(30),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Colors.grey.withOpacity(0.2),
                      //         blurRadius: 7,
                      //         spreadRadius: 1,
                      //         offset: const Offset(1, 1),
                      //       )
                      //     ],
                      //   ),
                      //   child: TextField(
                      //     decoration: InputDecoration(
                      //       focusedBorder: OutlineInputBorder(
                      //         borderSide:
                      //             BorderSide(color: Colors.white, width: 1.0),
                      //         borderRadius: BorderRadius.circular(30),
                      //       ),
                      //       enabledBorder: OutlineInputBorder(
                      //         borderSide:
                      //             BorderSide(color: Colors.white, width: 1.0),
                      //         borderRadius: BorderRadius.circular(30),
                      //       ),
                      //       hintText: "UserName",
                      //       hintStyle: TextStyle(color: Colors.grey[500]),
                      //       prefixIcon: Icon(
                      //         Icons.person_2_outlined,
                      //         color: Colors.grey[500],
                      //       ),
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(30),
                      //       ),
                      //     ),
                      //   ),
                      // ),