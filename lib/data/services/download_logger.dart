import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:server_core/server_core.dart';

import '../models/aggregated_item.dart';
import '../models/download_quality.dart';

/// Persistent, append-only download activity log.
///
/// **Local buffer**: One log file per calendar day under
///   `<app-documents>/Moonfin/Logs/download_YYYY-MM-DD.log`.
///
/// **Server upload**: After each significant event (complete / failed /
///   cancelled / batch-complete) the full day's log is uploaded to the
///   Jellyfin server via `POST /ClientLog/Document`. It then appears in the
///   admin panel → Logs section as `moonfin_downloads_YYYY-MM-DD_HHmmss.log`.
///   Uploads are throttled to at most once per 60 seconds and silently
///   ignored if the server is offline or not Jellyfin.
///
/// Events logged:
///   QUEUED / STARTED / PROGRESS / VERIFIED / COMPLETE /
///   CANCELLED / FAILED / WARN / BATCH / RECOVERED
class DownloadLogger {
  File? _logFile;
  DateTime? _logDate;
  Future<void> _writeQueue = Future.value();

  final Map<String, double> _milestones = {};

  DateTime? _lastUpload;

  final Dio _uploadDio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ));

  Future<File> _getLogFile() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_logFile != null && _logDate == today) return _logFile!;

    final docs = await getApplicationDocumentsDirectory();
    final logsDir = Directory('${docs.path}/Moonfin/Logs');
    if (!await logsDir.exists()) {
      await logsDir.create(recursive: true);
    }

    final dateStr = _dateStr(now);
    _logFile = File('${logsDir.path}/download_$dateStr.log');
    _logDate = today;

    if (!await _logFile!.exists()) {
      await _logFile!.writeAsString(
        '# Moonfin Download Log — $dateStr\n'
        '#\n'
        '# Columns: TIMESTAMP | LEVEL | MEDIA_TYPE | TITLE | CONTAINER | CODEC | QUALITY | EXTRA\n'
        '# Levels: QUEUED / STARTED / PROGRESS / VERIFIED / COMPLETE /'
        ' CANCELLED / FAILED / WARN / BATCH / RECOVERED\n'
        '#\n',
        flush: true,
      );
    }

    return _logFile!;
  }

  Future<void> _write(String line) async {
    _writeQueue = _writeQueue.catchError((_) {}).then((_) async {
      try {
        final file = await _getLogFile();
        await file.writeAsString('$line\n', mode: FileMode.append, flush: true);
      } catch (e) {
        if (kDebugMode) debugPrint('[DownloadLogger] write error: $e');
      }
    });

    await _writeQueue;
  }

  String _timestamp() {
    final t = DateTime.now();
    return '${_pad4(t.year)}-${_pad(t.month)}-${_pad(t.day)} '
        '${_pad(t.hour)}:${_pad(t.minute)}:${_pad(t.second)}';
  }

  String _dateStr(DateTime d) =>
      '${_pad4(d.year)}-${_pad(d.month)}-${_pad(d.day)}';

  String _pad(int n) => n.toString().padLeft(2, '0');
  String _pad4(int n) => n.toString().padLeft(4, '0');

  String _levelPad(String level) => level.padRight(9);

  String _typePad(String? type) => (type ?? 'Unknown').padRight(9);

  // ─── item description ────────────────────────────────────────────────────

  String _describeItem(AggregatedItem item) {
    switch (item.type) {
      case 'Movie':
        final year = item.productionYear;
        return year != null ? '${item.name} ($year)' : item.name;

      case 'Episode':
        final s = item.parentIndexNumber;
        final e = item.indexNumber;
        final series = item.seriesName ?? 'Unknown Series';
        if (s != null && e != null) {
          return '$series S${_pad(s)}E${_pad(e)} — ${item.name}';
        }
          return '$series: ${item.name}';

      case 'Audio':
        final artist = item.albumArtist ??
            (item.artists.isNotEmpty ? item.artists.first : null);
        final album = item.album;
        if (artist != null && album != null) {
          return '$artist / $album / ${item.name}';
        }
        if (artist != null) return '$artist — ${item.name}';
        return item.name;

      case 'AudioBook':
        final author = item.albumArtist ??
            (item.artists.isNotEmpty ? item.artists.first : null);
        return author != null
            ? '${item.name} by $author [Audiobook]'
            : '${item.name} [Audiobook]';

      case 'Book':
        return '${item.name} [Book]';

      default:
        return item.name;
    }
  }

  String _qualityDesc(DownloadQuality quality) =>
      quality.isTranscoded ? 'Transcoded (${quality.label})' : 'Original';

  String _containerOf(AggregatedItem item, DownloadQuality quality) {
    if (item.type == 'Book') return 'book';
    if (quality.isTranscoded) return quality.container;
    if (item.mediaSources.isNotEmpty) {
      return (item.mediaSources.first['Container'] as String? ?? '?')
          .toLowerCase();
    }
    return '?';
  }

  String _codecOf(AggregatedItem item, DownloadQuality quality) {
    if (quality.isTranscoded) {
      return '${quality.videoCodec}+${quality.audioCodec}';
    }
    // Try video codec first, then audio codec for audio-only items.
    final video = item.videoCodec;
    if (video != null) {
      final audio = _audioCodecOf(item);
      return audio != null ? '$video+$audio' : video;
    }
    final audio = _audioCodecOf(item);
    return audio ?? '?';
  }

  String? _audioCodecOf(AggregatedItem item) {
    for (final stream in item.mediaStreams) {
      if (stream['Type'] == 'Audio') {
        return stream['Codec'] as String?;
      }
    }
    return null;
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) return '${h}h ${m}m ${s}s';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  String _telemetrySuffix(Map<String, Object?>? telemetry) {
    if (telemetry == null || telemetry.isEmpty) {
      return '';
    }

    final clean = <String, Object?>{};
    telemetry.forEach((key, value) {
      if (value == null) {
        return;
      }

      clean[key] = value;
    });

    if (clean.isEmpty) {
      return '';
    }

    return ' | telemetry=${jsonEncode(clean)}';
  }

  // ─── public API ──────────────────────────────────────────────────────────

  /// Called when an item enters the queue (before any network activity).
  Future<void> logQueued(
    AggregatedItem item,
    DownloadQuality quality, {
    int? batchIndex,
    int? batchTotal,
    Map<String, Object?>? telemetry,
  }) async {
    final extra = (batchIndex != null && batchTotal != null)
        ? ' [batch item $batchIndex / $batchTotal]'
        : '';
    await _write(
      '${_timestamp()} | ${_levelPad('QUEUED')} | ${_typePad(item.type)} | '
      '${_describeItem(item)} | ${_qualityDesc(quality)}$extra${_telemetrySuffix(telemetry)}',
    );
  }

  /// Called when the HTTP download actually begins.
  Future<void> logStarted(
    AggregatedItem item,
    DownloadQuality quality,
    {Map<String, Object?>? telemetry}
  ) async {
    _milestones[item.id] = 0.0;
    final container = _containerOf(item, quality);
    final codec = _codecOf(item, quality);
    final estSize = item.mediaSources.isNotEmpty
        ? item.mediaSources.first['Size'] as int?
        : null;
    final estStr = estSize != null ? _formatBytes(estSize) : 'unknown size';

    await _write(
      '${_timestamp()} | ${_levelPad('STARTED')} | ${_typePad(item.type)} | '
      '${_describeItem(item)} | $container | $codec | ${_qualityDesc(quality)} | est. $estStr${_telemetrySuffix(telemetry)}',
    );
  }

  /// Call from the `onReceiveProgress` callback.
  /// Only writes at 25 %, 50 %, 75 %, and 100 % milestones to avoid flooding.
  Future<void> logProgress(
    AggregatedItem item,
    double progress,
    int bytesReceived,
    {Map<String, Object?>? telemetry}
  ) async {
    if (progress < 0) return; // transcoded indeterminate
    final milestones = [0.25, 0.50, 0.75, 1.0];
    final last = _milestones[item.id] ?? 0.0;
    for (final m in milestones) {
      if (progress >= m && last < m) {
        _milestones[item.id] = m;
        final pct = (m * 100).toStringAsFixed(0);
        await _write(
          '${_timestamp()} | ${_levelPad('PROGRESS')} | ${_typePad(item.type)} | '
          '${_describeItem(item)} | $pct% — ${_formatBytes(bytesReceived)} received${_telemetrySuffix(telemetry)}',
        );
        break; // only one milestone per call
      }
    }
  }

  /// Called after the downloaded file has been stat'd and confirmed > 0 bytes.
  Future<void> logFileVerified(AggregatedItem item, int fileBytes, {Map<String, Object?>? telemetry}) async {
    await _write(
      '${_timestamp()} | ${_levelPad('VERIFIED')} | ${_typePad(item.type)} | '
      '${_describeItem(item)} | ${_formatBytes(fileBytes)} on disk${_telemetrySuffix(telemetry)}',
    );
  }

  /// Called when a 0-byte file is found immediately after download.
  Future<void> logZeroByteFile(AggregatedItem item, {Map<String, Object?>? telemetry}) async {
    await _write(
      '${_timestamp()} | ${_levelPad('WARN')} | ${_typePad(item.type)} | '
      '${_describeItem(item)} | *** 0-byte file detected — download considered failed ***${_telemetrySuffix(telemetry)}',
    );
  }

  /// Called when the item is fully saved and the DB has been updated.
  Future<void> logComplete(
    AggregatedItem item,
    DownloadQuality quality,
    int finalBytes,
    Duration elapsed,
    {Map<String, Object?>? telemetry}
  ) async {
    _milestones.remove(item.id);
    await _write(
      '${_timestamp()} | ${_levelPad('COMPLETE')} | ${_typePad(item.type)} | '
      '${_describeItem(item)} | ${_qualityDesc(quality)} | '
      '${_formatBytes(finalBytes)} | ${_formatDuration(elapsed)}${_telemetrySuffix(telemetry)}',
    );
  }

  /// Called when the user cancels a download.
  Future<void> logCancelled(AggregatedItem item, {Map<String, Object?>? telemetry}) async {
    _milestones.remove(item.id);
    await _write(
      '${_timestamp()} | ${_levelPad('CANCELLED')} | ${_typePad(item.type)} | '
      '${_describeItem(item)}${_telemetrySuffix(telemetry)}',
    );
  }

  /// Called when a download fails (network error, auth error, etc.).
  Future<void> logFailed(
    AggregatedItem item,
    DownloadQuality quality,
    String error,
    {Map<String, Object?>? telemetry}
  ) async {
    _milestones.remove(item.id);
    await _write(
      '${_timestamp()} | ${_levelPad('FAILED')} | ${_typePad(item.type)} | '
      '${_describeItem(item)} | ${_qualityDesc(quality)} | $error${_telemetrySuffix(telemetry)}',
    );
  }

  /// Generic warning (WiFi policy, storage limit, etc.).
  Future<void> logWarn(AggregatedItem item, String message, {Map<String, Object?>? telemetry}) async {
    await _write(
      '${_timestamp()} | ${_levelPad('WARN')} | ${_typePad(item.type)} | '
      '${_describeItem(item)} | $message${_telemetrySuffix(telemetry)}',
    );
  }

  /// Called at the start of a batch download.
  Future<void> logBatchStarted(int total, DownloadQuality quality, {Map<String, Object?>? telemetry}) async {
    await _write(
      '${_timestamp()} | ${_levelPad('BATCH')} | -         | '
      'Starting batch of $total items | ${_qualityDesc(quality)}${_telemetrySuffix(telemetry)}',
    );
  }

  /// Called when a batch download finishes.
  Future<void> logBatchComplete(
    int completed,
    int total,
    Duration elapsed,
    {Map<String, Object?>? telemetry}
  ) async {
    await _write(
      '${_timestamp()} | ${_levelPad('BATCH')} | -         | '
      'Batch complete: $completed / $total | ${_formatDuration(elapsed)}${_telemetrySuffix(telemetry)}',
    );
  }

  /// Called during startup recovery when an interrupted download is re-queued or marked failed.
  Future<void> logRecovered(String itemId, String itemName, String resolution, {Map<String, Object?>? telemetry}) async {
    await _write(
      '${_timestamp()} | ${_levelPad('RECOVERED')} | -         | '
      '"$itemName" ($itemId) | $resolution${_telemetrySuffix(telemetry)}',
    );
  }

  // ─── server upload ───────────────────────────────────────────────────────

  /// Uploads today's full log to the Jellyfin server so it appears in the
  /// admin panel → Logs section.
  ///
  /// Call this after every COMPLETE / FAILED / CANCELLED / BATCH event.
  /// Uploads are silently skipped when:
  ///  • the server type is not Jellyfin
  ///  • fewer than 60 seconds have elapsed since the last upload
  ///  • the server returns an error (the local file is always preserved)
  Future<void> uploadToServer(MediaServerClient client) async {
    if (client.serverType != ServerType.jellyfin) return;

    final now = DateTime.now();
    if (_lastUpload != null &&
        now.difference(_lastUpload!).inSeconds < 60) {
      return;
    }

    try {
      final file = await _getLogFile();
      if (!await file.exists()) return;

      var content = await file.readAsString();

      // Jellyfin caps the upload at 1 MB; keep the tail of the log if needed.
      const maxBytes = 950 * 1024;
      if (content.length > maxBytes) {
        content =
            '=== log truncated — showing last ${maxBytes ~/ 1024} KB ===\n\n'
            '${content.substring(content.length - maxBytes)}';
      }

      final token = client.accessToken;
      if (token == null || token.isEmpty) return;

      await _uploadDio.post(
        '${client.baseUrl}/ClientLog/Document',
        data: content,
        options: Options(
          contentType: 'text/plain',
          headers: {
            'X-Emby-Token': token,
            'Authorization': 'MediaBrowser Token="$token"',
          },
        ),
      );

      _lastUpload = now;
    } catch (e) {
      // Never fail the calling code because of a logging upload error.
      if (kDebugMode) debugPrint('[DownloadLogger] server upload error: $e');
    }
  }

  // ─── log file access ─────────────────────────────────────────────────────

  /// Returns path to today's log file (creating it if needed).
  Future<String?> getTodayLogPath() async {
    try {
      return (await _getLogFile()).path;
    } catch (_) {
      return null;
    }
  }

  /// Returns all log files, newest first.
  Future<List<File>> getAllLogFiles() async {
    try {
      final docs = await getApplicationDocumentsDirectory();
      final logsDir = Directory('${docs.path}/Moonfin/Logs');
      if (!await logsDir.exists()) return [];
      final files = await logsDir
          .list()
          .where((e) => e is File && e.path.endsWith('.log'))
          .cast<File>()
          .toList();
      files.sort((a, b) => b.path.compareTo(a.path));
      return files;
    } catch (_) {
      return [];
    }
  }

  /// Reads the contents of today's log, returning an empty string on error.
  Future<String> readTodayLog() async {
    try {
      final file = await _getLogFile();
      if (!await file.exists()) return '';
      return await file.readAsString();
    } catch (_) {
      return '';
    }
  }

  /// Reads the contents of a specific log file, returning an empty string on error.
  Future<String> readLogFile(File file) async {
    try {
      return await file.readAsString();
    } catch (_) {
      return '';
    }
  }

  /// Deletes log files older than [keepDays] days to avoid unbounded growth.
  Future<void> pruneOldLogs({int keepDays = 30}) async {
    try {
      final files = await getAllLogFiles();
      final cutoff = DateTime.now().subtract(Duration(days: keepDays));
      for (final file in files) {
        final name = file.path.split(Platform.pathSeparator).last;
        // Extract date from "download_YYYY-MM-DD.log"
        final match = RegExp(r'(\d{4}-\d{2}-\d{2})').firstMatch(name);
        if (match == null) continue;
        final date = DateTime.tryParse(match.group(1)!);
        if (date != null && date.isBefore(cutoff)) {
          await file.delete();
        }
      }
    } catch (_) {}
  }
}
