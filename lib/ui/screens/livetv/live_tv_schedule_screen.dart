import 'package:flutter/material.dart';

class LiveTvScheduleScreen extends StatelessWidget {
  const LiveTvScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
      body: const Center(child: Text('Recording schedule will appear here')),
    );
  }
}
