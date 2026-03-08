import 'package:flutter/material.dart';

class LiveTvRecordingsScreen extends StatelessWidget {
  const LiveTvRecordingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recordings')),
      body: const Center(child: Text('Recordings will appear here')),
    );
  }
}
