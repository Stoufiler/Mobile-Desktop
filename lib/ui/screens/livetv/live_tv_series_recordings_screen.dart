import 'package:flutter/material.dart';

class LiveTvSeriesRecordingsScreen extends StatelessWidget {
  const LiveTvSeriesRecordingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Series Recordings')),
      body: const Center(child: Text('Series recordings will appear here')),
    );
  }
}
