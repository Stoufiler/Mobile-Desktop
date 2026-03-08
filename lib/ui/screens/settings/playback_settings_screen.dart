import 'package:flutter/material.dart';

class PlaybackSettingsScreen extends StatelessWidget {
  const PlaybackSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playback')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.videocam),
            title: Text('Max Streaming Bitrate'),
            subtitle: Text('Auto'),
          ),
          ListTile(
            leading: Icon(Icons.speed),
            title: Text('Max Resolution'),
            subtitle: Text('Auto'),
          ),
          ListTile(
            leading: Icon(Icons.skip_next),
            title: Text('Next Up Behavior'),
            subtitle: Text('Show after playback'),
          ),
          ListTile(
            leading: Icon(Icons.surround_sound),
            title: Text('Audio Behavior'),
            subtitle: Text('Default'),
          ),
        ],
      ),
    );
  }
}
