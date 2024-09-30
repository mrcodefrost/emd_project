import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double progressValue;
  const ProgressBar({super.key, required this.progressValue});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: LinearProgressIndicator(
          value: progressValue,
          minHeight: 4,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          backgroundColor: Colors.grey.shade700,
        ),
      ),
    );
  }
}
