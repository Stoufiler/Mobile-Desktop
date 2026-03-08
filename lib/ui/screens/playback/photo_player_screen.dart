import 'package:flutter/material.dart';

class PhotoPlayerScreen extends StatelessWidget {
  final String itemId;

  const PhotoPlayerScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: const Center(
        child: Text(
          'Photo viewer will appear here',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
