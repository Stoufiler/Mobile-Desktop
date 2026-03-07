import 'player_backend.dart';
import 'player_state.dart';
import 'queue_service.dart';

/// Orchestrates playback state, services, and backends.
class PlaybackManager {
  PlayerBackend? _backend;
  final QueueService queueService = QueueService();
  final PlayerState state = PlayerState();

  PlayerBackend? get backend => _backend;

  void setBackend(PlayerBackend backend) {
    _backend?.dispose();
    _backend = backend;
  }

  Future<void> play() async {
    final item = queueService.currentItem;
    if (item == null || _backend == null) return;
    await _backend!.play(item);
    state.setPlaying(true);
  }

  Future<void> pause() async {
    await _backend?.pause();
    state.setPlaying(false);
  }

  Future<void> stop() async {
    await _backend?.stop();
    state.reset();
  }

  Future<void> seekTo(Duration position) async {
    await _backend?.seekTo(position);
  }

  Future<void> next() async {
    if (queueService.hasNext) {
      queueService.next();
      await play();
    }
  }

  Future<void> previous() async {
    if (queueService.hasPrevious) {
      queueService.previous();
      await play();
    }
  }

  void dispose() {
    _backend?.dispose();
    state.dispose();
  }
}
