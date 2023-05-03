// ignore_for_file: non_constant_identifier_names

import 'package:compiler/CompilerScreen.dart';
import 'package:flutter/material.dart';

Widget ClearBtn({required BuildContext context}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const CompilerScreen(),
                ));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff141d3d),
          ),
          child: const Text(
            'Clear',
            style: TextStyle(color: Color(0xFF624ad4)),
          )),
    ),
  );
}

Widget GoBtn({required VoidCallback onTap}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color(0xFF624ad4), // Change this to the desired color
          ),
          child: const Text(
            'GO',
            style: TextStyle(color: Colors.white),
          )),
    ),
  );
}

Widget TokenOutput({required String tokenString}) {
  return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 6.0),
            child: Text(
              'Tokens',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(color: const Color(0xFFffffff))),
            child: Text(
              tokenString,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ));
}

Widget SyntaxOutput({required String errorMsg, required bool errorExist}) {
  return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 6.0),
            child: Text(
              'Syntax Analysis',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(color: const Color(0xFFffffff))),
            child: Text(
              errorMsg,
              style: TextStyle(
                  color: Color(errorExist ? 0xffff0000 : 0xFF624ad4),
                  fontSize: 20),
            ),
          ),
        ],
      ));
}
