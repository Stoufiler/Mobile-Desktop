import 'package:flutter/material.dart';

class ParentalSettingsScreen extends StatelessWidget {
  const ParentalSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parental Controls')),
      body: const Center(
        child: Text('Blocked ratings configuration will appear here'),
      ),
    );
  }
}
