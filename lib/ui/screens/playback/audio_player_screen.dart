import 'package:flutter/material.dart';

class AudioPlayerScreen extends StatelessWidget {
  const AudioPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Now Playing')),
      body: const Center(child: Text('Audio player will appear here')),
    );
  }
}
