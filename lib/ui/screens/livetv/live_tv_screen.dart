import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/destinations.dart';

class LiveTvScreen extends StatelessWidget {
  const LiveTvScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live TV')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.tv),
            title: const Text('Guide'),
            onTap: () => context.push(Destinations.liveTvGuide),
          ),
          ListTile(
            leading: const Icon(Icons.fiber_dvr),
            title: const Text('Recordings'),
            onTap: () => context.push(Destinations.liveTvRecordings),
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Schedule'),
            onTap: () => context.push(Destinations.liveTvSchedule),
          ),
          ListTile(
            leading: const Icon(Icons.repeat),
            title: const Text('Series Recordings'),
            onTap: () => context.push(Destinations.liveTvSeriesRecordings),
          ),
        ],
      ),
    );
  }
}
