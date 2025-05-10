import 'package:flutter/material.dart';

Widget buildButton(String text, VoidCallback onPressed) {
  return SizedBox(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(vertical: 15),
          elevation: 2, 
        ),
       onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: Color.fromARGB(255, 7, 140, 27), 
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

