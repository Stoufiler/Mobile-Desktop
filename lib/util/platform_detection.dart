import 'dart:io';
import 'package:flutter/foundation.dart';

class PlatformDetection {
  const PlatformDetection._();

  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  static bool get isWindows => !kIsWeb && Platform.isWindows;
  static bool get isLinux => !kIsWeb && Platform.isLinux;
  static bool get isWeb => kIsWeb;

  static bool get isMobile => isAndroid || isIOS;
  static bool get isDesktop => isMacOS || isWindows || isLinux;

  static bool get isTV => _isTv;
  static bool _isTv = false;
  static void setTvMode(bool value) => _isTv = value;

  /// Whether to use a 10-foot (lean-back) UI optimized for remote control.
  static bool get useLeanbackUi => isTV;
  static bool get useDesktopUi => isDesktop && !isTV;
  static bool get useMobileUi => isMobile && !isTV;
}
