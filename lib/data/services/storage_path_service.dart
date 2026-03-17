import 'dart:io';

import 'package:path_provider/path_provider.dart';

class StoragePathService {
  Directory? _cachedRoot;

  Future<Directory> getOfflineRoot() async {
    if (_cachedRoot != null) return _cachedRoot!;

    Directory dir;
    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download/Moonfin');
      if (!await dir.exists()) {
        try {
          await dir.create(recursive: true);
        } catch (_) {
          final extDirs = await getExternalStorageDirectories();
          final base = extDirs != null && extDirs.isNotEmpty
              ? extDirs.first
              : await getApplicationDocumentsDirectory();
          dir = Directory('${base.path}/Moonfin');
          await dir.create(recursive: true);
        }
      }
    } else if (Platform.isIOS) {
      final docs = await getApplicationDocumentsDirectory();
      dir = Directory('${docs.path}/Moonfin');
    } else {
      final support = await getApplicationSupportDirectory();
      dir = Directory('${support.path}/Downloads');
    }

    if (!await dir.exists()) await dir.create(recursive: true);
    _cachedRoot = dir;
    return dir;
  }

  Future<File> getDatabaseFile() async {
    final docs = await getApplicationDocumentsDirectory();
    final dbDir = Directory('${docs.path}/Moonfin/DB');
    if (!await dbDir.exists()) await dbDir.create(recursive: true);
    return File('${dbDir.path}/offline.db');
  }

  Future<Directory> getImageCacheDir() async {
    final root = await getOfflineRoot();
    final dir = Directory('${root.path}/images');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }
}
