import 'package:flutter/material.dart';

class Medicinetypetile extends StatelessWidget {
  final IconData icon;
  const Medicinetypetile({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Icon(
        icon,
        color: Colors.pinkAccent,
        size: 40,
      ),
    );
  }
}