import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/destinations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SettingsSection(title: 'Playback'),
          ListTile(
            leading: const Icon(Icons.videocam),
            title: const Text('Playback'),
            subtitle: const Text('Bitrate, resolution, behavior'),
            onTap: () => context.push(Destinations.settingsPlayback),
          ),
          ListTile(
            leading: const Icon(Icons.subtitles),
            title: const Text('Subtitles'),
            subtitle: const Text('Language, size, appearance'),
            onTap: () => context.push(Destinations.settingsSubtitles),
          ),
          const _SettingsSection(title: 'Customization'),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Appearance'),
            subtitle: const Text('Theme, focus color, indicators'),
            onTap: () => context.push(Destinations.settingsAppearance),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home Sections'),
            subtitle: const Text('Configure home screen layout'),
            onTap: () => context.push(Destinations.settingsHomeSections),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Screensaver'),
            subtitle: const Text('Timeout, dimming'),
            onTap: () => context.push(Destinations.settingsScreensaver),
          ),
          const _SettingsSection(title: 'Account'),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Authentication'),
            subtitle: const Text('Auto login, PIN, user sort'),
            onTap: () => context.push(Destinations.settingsAuth),
          ),
          ListTile(
            leading: const Icon(Icons.child_care),
            title: const Text('Parental Controls'),
            subtitle: const Text('Content rating restrictions'),
            onTap: () => context.push(Destinations.settingsParental),
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Switch Server'),
            onTap: () => context.go(Destinations.serverSelect),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () => context.go(Destinations.serverSelect),
          ),
          const _SettingsSection(title: 'About'),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            subtitle: const Text('Version, licenses'),
            onTap: () => context.push(Destinations.settingsAbout),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;

  const _SettingsSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
