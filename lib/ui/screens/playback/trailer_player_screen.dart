import 'package:flutter/material.dart';

class TrailerPlayerScreen extends StatelessWidget {
  final String? videoId;

  const TrailerPlayerScreen({super.key, this.videoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: const Center(
        child: Text(
          'Trailer player will appear here',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
