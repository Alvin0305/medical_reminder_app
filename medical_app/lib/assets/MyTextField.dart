import 'package:flutter/material.dart';

class Mytextfield extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const Mytextfield({super.key,  required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(
              width: 0,
            )
        ),
        filled: true,
        fillColor: Colors.black12,
        hintText: label,
        hintStyle: const TextStyle(
          color: Colors.black45,
        ),
      ),
    );
  }
}