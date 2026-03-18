import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:playback_core/playback_core.dart';

/// Preserves audio playback position/state across app lifecycle transitions.
class PlaybackLifecycleHandler with WidgetsBindingObserver {
  final PlaybackManager _manager;
  Duration? _savedPosition;
  bool? _wasPlaying;

  PlaybackLifecycleHandler(this._manager) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        _saveState();
        break;
      case AppLifecycleState.resumed:
        _restoreState();
        break;
      default:
        break;
    }
  }

  void _saveState() {
    if (_savedPosition != null) return;
    if (_manager.queueService.currentItem == null) return;

    _savedPosition = _manager.state.position;
    _wasPlaying = _manager.state.isPlaying;
  }

  Future<void> _restoreState() async {
    final savedPos = _savedPosition;
    final wasPlaying = _wasPlaying;
    _savedPosition = null;
    _wasPlaying = null;

    if (savedPos == null || wasPlaying == null) return;
    if (_manager.queueService.currentItem == null) return;

    await Future.delayed(const Duration(milliseconds: 1500));

    if (_manager.queueService.currentItem == null) return;

    if (!wasPlaying && _manager.state.isPlaying) {
      await _manager.pause();
    }

    final currentPos = _manager.backend?.position ?? _manager.state.position;
    if (savedPos > const Duration(seconds: 3) &&
        currentPos < savedPos - const Duration(seconds: 5)) {
      await _manager.seekTo(savedPos);

      await Future.delayed(const Duration(milliseconds: 350));
      final verifyPos = _manager.backend?.position ?? _manager.state.position;
      if (verifyPos < savedPos - const Duration(seconds: 3)) {
        await _manager.seekTo(savedPos);
      }
    }

    if (wasPlaying && !_manager.state.isPlaying) {
      await _manager.resume();
    }
  }
}
