import 'package:flutter/material.dart';

class Mybutton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const Mybutton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pinkAccent, // Button color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        elevation: 5, // Elevation
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40), // Padding
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}