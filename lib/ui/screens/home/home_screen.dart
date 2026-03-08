import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/aggregated_item.dart';
import '../../../data/services/background_service.dart';
import '../../../preference/user_preferences.dart';
import '../../navigation/destinations.dart';
import '../../widgets/info_area.dart';
import '../../widgets/library_row.dart';
import '../../widgets/responsive_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: _HomeShell(),
      tvBody: _HomeShell(),
    );
  }
}

class _HomeShell extends StatefulWidget {
  const _HomeShell();

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  final _backgroundService = GetIt.instance<BackgroundService>();
  final _userPrefs = GetIt.instance<UserPreferences>();

  AggregatedItem? _selectedItem;
  String? _backdropUrl;
  Timer? _selectionDebounce;
  Timer? _backdropDebounce;
  StreamSubscription<String?>? _backgroundSub;

  static const _selectionDelay = Duration(milliseconds: 150);
  static const _backdropDelay = Duration(milliseconds: 200);
  static const _infoAreaTop = 80.0;
  static const _contentTop = 243.0;

  @override
  void initState() {
    super.initState();
    _backgroundSub = _backgroundService.backgroundStream.listen((url) {
      if (mounted) setState(() => _backdropUrl = url);
    });
    _backdropUrl = _backgroundService.currentUrl;
  }

  @override
  void dispose() {
    _selectionDebounce?.cancel();
    _backdropDebounce?.cancel();
    _backgroundSub?.cancel();
    super.dispose();
  }

  void onItemSelected(AggregatedItem? item) {
    _selectionDebounce?.cancel();
    _selectionDebounce = Timer(_selectionDelay, () {
      if (!mounted) return;
      setState(() => _selectedItem = item);

      _backdropDebounce?.cancel();
      _backdropDebounce = Timer(_backdropDelay, () {
        _backgroundService.setBackground(item, context: BlurContext.browsing);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final backdropEnabled = _userPrefs.get(UserPreferences.backdropEnabled);
    final blurAmount = _userPrefs.get(UserPreferences.browsingBackgroundBlurAmount).toDouble();

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Moonfin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push(Destinations.search),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(Destinations.settings),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (backdropEnabled) _Backdrop(url: _backdropUrl, blurAmount: blurAmount),
          const _GradientScrim(),
          Positioned(
            left: 48,
            top: _infoAreaTop,
            child: SafeArea(
              child: InfoArea(item: _selectedItem),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: _contentTop,
            bottom: 0,
            child: _ContentRows(onItemSelected: onItemSelected),
          ),
        ],
      ),
    );
  }
}

class _Backdrop extends StatelessWidget {
  final String? url;
  final double blurAmount;

  const _Backdrop({this.url, required this.blurAmount});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: BackgroundService.transitionDuration,
      child: url != null
          ? SizedBox.expand(
              key: ValueKey(url),
              child: _blurredImage(url!, blurAmount),
            )
          : const SizedBox.expand(key: ValueKey('empty')),
    );
  }

  Widget _blurredImage(String imageUrl, double blur) {
    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      fadeInDuration: Duration.zero,
      errorWidget: (_, __, ___) => const SizedBox.shrink(),
    );
    if (blur <= 0) return image;
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: blur,
        sigmaY: blur,
        tileMode: TileMode.decal,
      ),
      child: image,
    );
  }
}

class _GradientScrim extends StatelessWidget {
  const _GradientScrim();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xAA000000),
            Color(0x44000000),
            Color(0xBB000000),
          ],
          stops: [0.0, 0.3, 1.0],
        ),
      ),
      child: SizedBox.expand(),
    );
  }
}

class _ContentRows extends StatelessWidget {
  final ValueChanged<AggregatedItem?> onItemSelected;

  const _ContentRows({required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        LibraryRow(title: 'Continue Watching', children: const []),
        LibraryRow(title: 'Next Up', children: const []),
        LibraryRow(title: 'Latest Media', children: const []),
        LibraryRow(title: 'My Libraries', children: const []),
      ],
    );
  }
}
