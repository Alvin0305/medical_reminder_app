import 'package:flutter/material.dart';
import 'Medicine.dart';

class Profilepagetile extends StatelessWidget {
  final Medicine medicine;

  Profilepagetile({
    super.key,
    required this.medicine,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4), // Subtle shadow below
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  medicine.icon,
                  const SizedBox(width: 10),
                  Text(
                    medicine.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Times Row
          ...List.generate(
            (medicine.times.length / 2).ceil(),
            (index) {
              // Get items for the current row
              final first = medicine.times[index * 2];
              final second = index * 2 + 1 < medicine.times.length ? medicine.times[index * 2 + 1] : null;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTimeBox(first, Colors.deepPurpleAccent),
                    if (second != null) _buildTimeBox(second, Colors.pinkAccent),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper function to build a time box with rounded corners and a background color
  Widget _buildTimeBox(String time, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              time,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
