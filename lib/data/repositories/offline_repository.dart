import 'dart:convert';

import 'package:drift/drift.dart';

import '../database/offline_database.dart';

class OfflineRepository {
  final OfflineDatabase _db;

  OfflineRepository(this._db);

  Future<void> upsertItem(DownloadedItemsCompanion item) async {
    await _db.into(_db.downloadedItems).insertOnConflictUpdate(item);
  }

  Future<void> updateDownloadStatus(
    String itemId,
    String serverId,
    int status, {
    double? progress,
    String? error,
  }) async {
    await (_db.update(_db.downloadedItems)
          ..where((t) => t.itemId.equals(itemId) & t.serverId.equals(serverId)))
        .write(DownloadedItemsCompanion(
      downloadStatus: Value(status),
      downloadProgress: progress != null ? Value(progress) : const Value.absent(),
      errorMessage: Value(error),
      downloadedAt: status == 2 ? Value(DateTime.now()) : const Value.absent(),
    ));
  }

  Future<void> setLocalFilePath(String itemId, String serverId, String path, {int? fileSize}) async {
    await (_db.update(_db.downloadedItems)
          ..where((t) => t.itemId.equals(itemId) & t.serverId.equals(serverId)))
        .write(DownloadedItemsCompanion(
      localFilePath: Value(path),
      fileSizeBytes: fileSize != null ? Value(fileSize) : const Value.absent(),
    ));
  }

  Future<void> setImagePaths(
    String itemId,
    String serverId, {
    String? poster,
    String? backdrop,
    String? logo,
    String? thumb,
  }) async {
    await (_db.update(_db.downloadedItems)
          ..where((t) => t.itemId.equals(itemId) & t.serverId.equals(serverId)))
        .write(DownloadedItemsCompanion(
      posterPath: poster != null ? Value(poster) : const Value.absent(),
      backdropPath: backdrop != null ? Value(backdrop) : const Value.absent(),
      logoPath: logo != null ? Value(logo) : const Value.absent(),
      thumbPath: thumb != null ? Value(thumb) : const Value.absent(),
    ));
  }

  Future<void> updatePlaybackPosition(String itemId, String serverId, int positionTicks) async {
    await (_db.update(_db.downloadedItems)
          ..where((t) => t.itemId.equals(itemId) & t.serverId.equals(serverId)))
        .write(DownloadedItemsCompanion(
      playbackPositionTicks: Value(positionTicks),
      progressSynced: const Value(false),
    ));
  }

  Future<void> markProgressSynced(String itemId, String serverId) async {
    await (_db.update(_db.downloadedItems)
          ..where((t) => t.itemId.equals(itemId) & t.serverId.equals(serverId)))
        .write(const DownloadedItemsCompanion(progressSynced: Value(true)));
  }

  Future<void> deleteItem(String itemId, String serverId) async {
    await (_db.delete(_db.downloadedItems)
          ..where((t) => t.itemId.equals(itemId) & t.serverId.equals(serverId)))
        .go();
  }

  Future<void> deleteSeriesItems(String seriesId, String serverId) async {
    await (_db.delete(_db.downloadedItems)
          ..where((t) =>
              t.serverId.equals(serverId) &
              (t.itemId.equals(seriesId) | t.seriesId.equals(seriesId))))
        .go();
  }

  Future<void> deleteSeasonItems(String seasonId, String serverId) async {
    await (_db.delete(_db.downloadedItems)
          ..where((t) =>
              t.serverId.equals(serverId) &
              (t.itemId.equals(seasonId) | t.seasonId.equals(seasonId))))
        .go();
  }

  Future<List<DownloadedItem>> getItems(String serverId, {String? type}) async {
    final query = _db.select(_db.downloadedItems)
      ..where((t) => t.serverId.equals(serverId));
    if (type != null) {
      query.where((t) => t.type.equals(type));
    }
    return query.get();
  }

  Future<DownloadedItem?> getItem(String itemId, String serverId) async {
    final query = _db.select(_db.downloadedItems)
      ..where((t) => t.itemId.equals(itemId) & t.serverId.equals(serverId));
    return query.getSingleOrNull();
  }

  Future<bool> isAvailableOffline(String itemId, String serverId) async {
    final item = await getItem(itemId, serverId);
    return item != null && item.downloadStatus == 2;
  }

  Future<List<DownloadedItem>> getUnsyncedProgress(String serverId) async {
    final query = _db.select(_db.downloadedItems)
      ..where((t) => t.serverId.equals(serverId) & t.progressSynced.equals(false));
    return query.get();
  }

  Future<List<DownloadedItem>> getSeriesEpisodes(String seriesId, String serverId) async {
    final query = _db.select(_db.downloadedItems)
      ..where((t) =>
          t.serverId.equals(serverId) &
          t.seriesId.equals(seriesId) &
          t.type.equals('Episode'))
      ..orderBy([
        (t) => OrderingTerm.asc(t.parentIndexNumber),
        (t) => OrderingTerm.asc(t.indexNumber),
      ]);
    return query.get();
  }

  Future<List<DownloadedItem>> getSeasonEpisodes(String seasonId, String serverId) async {
    final query = _db.select(_db.downloadedItems)
      ..where((t) =>
          t.serverId.equals(serverId) &
          t.seasonId.equals(seasonId) &
          t.type.equals('Episode'))
      ..orderBy([(t) => OrderingTerm.asc(t.indexNumber)]);
    return query.get();
  }

  Future<List<DownloadedItem>> getDownloadedSeries(String serverId) async {
    final query = _db.select(_db.downloadedItems)
      ..where((t) => t.serverId.equals(serverId) & t.type.equals('Series'));
    return query.get();
  }

  Future<List<DownloadedItem>> getDownloadedMovies(String serverId) async {
    final query = _db.select(_db.downloadedItems)
      ..where((t) =>
          t.serverId.equals(serverId) &
          t.type.equals('Movie') &
          t.downloadStatus.equals(2));
    return query.get();
  }

  Future<int> getTotalStorageUsed(String serverId) async {
    final result = await _db.customSelect(
      'SELECT COALESCE(SUM(file_size_bytes), 0) AS total FROM downloaded_items WHERE server_id = ?',
      variables: [Variable.withString(serverId)],
    ).getSingle();
    return result.read<int>('total');
  }

  Future<Map<String, int>> getCountsByType(String serverId) async {
    final items = await getItems(serverId);
    final counts = <String, int>{};
    for (final item in items) {
      counts[item.type] = (counts[item.type] ?? 0) + 1;
    }
    return counts;
  }

  Stream<List<DownloadedItem>> watchItems(String serverId, {String? type}) {
    final query = _db.select(_db.downloadedItems)
      ..where((t) => t.serverId.equals(serverId));
    if (type != null) {
      query.where((t) => t.type.equals(type));
    }
    return query.watch();
  }

  Stream<DownloadedItem?> watchItem(String itemId, String serverId) {
    final query = _db.select(_db.downloadedItems)
      ..where((t) => t.itemId.equals(itemId) & t.serverId.equals(serverId));
    return query.watchSingleOrNull();
  }

  Stream<int> watchTotalStorageUsed(String serverId) {
    return _db
        .customSelect(
          'SELECT COALESCE(SUM(file_size_bytes), 0) AS total FROM downloaded_items WHERE server_id = ?',
          variables: [Variable.withString(serverId)],
          readsFrom: {_db.downloadedItems},
        )
        .watch()
        .map((rows) => rows.first.read<int>('total'));
  }

  Stream<List<DownloadedItem>> watchDownloadedSeries(String serverId) {
    final query = _db.select(_db.downloadedItems)
      ..where((t) => t.serverId.equals(serverId) & t.type.equals('Series'));
    return query.watch();
  }

  Stream<List<DownloadedItem>> watchSeriesEpisodes(String seriesId, String serverId) {
    final query = _db.select(_db.downloadedItems)
      ..where((t) =>
          t.serverId.equals(serverId) &
          t.seriesId.equals(seriesId) &
          t.type.equals('Episode'))
      ..orderBy([
        (t) => OrderingTerm.asc(t.parentIndexNumber),
        (t) => OrderingTerm.asc(t.indexNumber),
      ]);
    return query.watch();
  }

  Stream<List<DownloadedItem>> watchSeasonEpisodes(String seasonId, String serverId) {
    final query = _db.select(_db.downloadedItems)
      ..where((t) =>
          t.serverId.equals(serverId) &
          t.seasonId.equals(seasonId) &
          t.type.equals('Episode'))
      ..orderBy([(t) => OrderingTerm.asc(t.indexNumber)]);
    return query.watch();
  }

  Map<String, dynamic> rowToRawData(DownloadedItem row) {
    return jsonDecode(row.metadataJson) as Map<String, dynamic>;
  }
}
