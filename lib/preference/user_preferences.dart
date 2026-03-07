import 'package:jellyfin_preference/jellyfin_preference.dart';

/// App-level user preferences.
class UserPreferences {
  final PreferenceStore _store;

  UserPreferences(this._store);

  // Playback preferences
  static const _keyDefaultAudioLang = 'pref_audio_language';
  static const _keyDefaultSubtitleLang = 'pref_subtitle_language';
  static const _keyExternalPlayer = 'pref_external_player';
  static const _keyMaxBitrate = 'pref_max_bitrate';
  static const _keyAutoPlay = 'pref_auto_play';

  // UI preferences
  static const _keyThemeMode = 'pref_theme_mode';
  static const _keyHomeSections = 'pref_home_sections';

  String get defaultAudioLanguage =>
      _store.getString(_keyDefaultAudioLang) ?? '';

  Future<void> setDefaultAudioLanguage(String lang) =>
      _store.setString(_keyDefaultAudioLang, lang);

  String get defaultSubtitleLanguage =>
      _store.getString(_keyDefaultSubtitleLang) ?? '';

  Future<void> setDefaultSubtitleLanguage(String lang) =>
      _store.setString(_keyDefaultSubtitleLang, lang);

  bool get useExternalPlayer => _store.getBool(_keyExternalPlayer) ?? false;

  Future<void> setUseExternalPlayer(bool value) =>
      _store.setBool(_keyExternalPlayer, value);

  int get maxBitrate => _store.getInt(_keyMaxBitrate) ?? 0; // 0 = auto

  Future<void> setMaxBitrate(int bitrate) =>
      _store.setInt(_keyMaxBitrate, bitrate);

  bool get autoPlay => _store.getBool(_keyAutoPlay) ?? true;

  Future<void> setAutoPlay(bool value) =>
      _store.setBool(_keyAutoPlay, value);

  String get themeMode => _store.getString(_keyThemeMode) ?? 'dark';

  Future<void> setThemeMode(String mode) =>
      _store.setString(_keyThemeMode, mode);

  List<String> get homeSections =>
      _store.getStringList(_keyHomeSections) ??
      ['resume', 'nextUp', 'latestMedia'];

  Future<void> setHomeSections(List<String> sections) =>
      _store.setStringList(_keyHomeSections, sections);
}
