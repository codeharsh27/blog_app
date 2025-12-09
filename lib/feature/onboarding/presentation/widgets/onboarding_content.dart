import 'package:flutter/material.dart';

class OnboardingContent extends StatelessWidget {
  final String title;
  final String description;
  final Widget content;
  final Color backgroundColor;
  final double? titleFontSize;

  const OnboardingContent({
    super.key,
    required this.title,
    required this.description,
    required this.content,
    required this.backgroundColor,
    this.titleFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80), // Space for top progress bar
          Text(
            title,
            style: TextStyle(
              fontSize: titleFontSize ?? 48,
              fontWeight: FontWeight.w900,
              height: 1.1,
              color: Colors.black,
              letterSpacing: -1.5,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 30),
          Center(child: content),
          const Spacer(),
          Text(
            description,
            style: const TextStyle(
              fontSize: 22,
              height: 1.5,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 120), // Space for bottom button area
        ],
      ),
    );
  }
}
