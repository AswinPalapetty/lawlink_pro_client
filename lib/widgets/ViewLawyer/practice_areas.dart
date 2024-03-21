import 'package:flutter/material.dart';

class PracticeAreas extends StatelessWidget {
  const PracticeAreas({
    super.key, required this.practiceArea,
  });

  final String practiceArea;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline,
          color: Color.fromARGB(255, 4, 143, 8),
        ),
        const Text(" "),
        Text(
          practiceArea,
          style: const TextStyle(fontSize: 16),
        )
      ],
    );
  }
}