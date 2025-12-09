import 'package:flutter/material.dart';

class LearnPage extends StatelessWidget {
  static const routeName = '/learn';
  
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Learn Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
