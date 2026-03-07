import 'dart:async';

class PlayerState {
  final _playingController = StreamController<bool>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();

  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;

  Stream<bool> get playingStream => _playingController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;

  void setPlaying(bool playing) {
    _isPlaying = playing;
    _playingController.add(playing);
  }

  void setPosition(Duration position) {
    _position = position;
    _positionController.add(position);
  }

  void setDuration(Duration duration) {
    _duration = duration;
    _durationController.add(duration);
  }

  void reset() {
    _isPlaying = false;
    _position = Duration.zero;
    _duration = Duration.zero;
    _playingController.add(false);
    _positionController.add(Duration.zero);
    _durationController.add(Duration.zero);
  }

  void dispose() {
    _playingController.close();
    _positionController.close();
    _durationController.close();
  }
}
