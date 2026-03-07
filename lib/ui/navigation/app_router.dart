import 'package:go_router/go_router.dart';

import '../screens/auth/startup_screen.dart';
import '../screens/auth/server_select_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/browse/library_browse_screen.dart';
import '../screens/detail/item_detail_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/playback/video_player_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/livetv/live_tv_screen.dart';
import 'destinations.dart';

/// Application router configuration.
final appRouter = GoRouter(
  initialLocation: Destinations.startup,
  routes: [
    GoRoute(
      path: Destinations.startup,
      builder: (context, state) => const StartupScreen(),
    ),
    GoRoute(
      path: Destinations.serverSelect,
      builder: (context, state) => const ServerSelectScreen(),
    ),
    GoRoute(
      path: Destinations.login,
      builder: (context, state) {
        final serverId = state.uri.queryParameters['serverId'] ?? '';
        return LoginScreen(serverId: serverId);
      },
    ),

    GoRoute(
      path: Destinations.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: Destinations.libraryBrowse,
      builder: (context, state) {
        final libraryId = state.pathParameters['libraryId']!;
        return LibraryBrowseScreen(libraryId: libraryId);
      },
    ),
    GoRoute(
      path: Destinations.itemDetail,
      builder: (context, state) {
        final itemId = state.pathParameters['itemId']!;
        return ItemDetailScreen(itemId: itemId);
      },
    ),
    GoRoute(
      path: Destinations.search,
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: Destinations.videoPlayer,
      builder: (context, state) => const VideoPlayerScreen(),
    ),
    GoRoute(
      path: Destinations.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: Destinations.liveTv,
      builder: (context, state) => const LiveTvScreen(),
    ),
  ],
);
