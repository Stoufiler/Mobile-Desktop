import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:server_core/server_core.dart';

import '../database/offline_database.dart';
import '../repositories/offline_repository.dart';

OfflineRepository get _repo => GetIt.instance<OfflineRepository>();

String _activeServerId() {
  if (GetIt.instance.isRegistered<MediaServerClient>()) {
    return GetIt.instance<MediaServerClient>().baseUrl;
  }
  return '';
}

final downloadedMoviesProvider = StreamProvider<List<DownloadedItem>>((ref) {
  return _repo.watchItems(_activeServerId(), type: 'Movie');
});

final downloadedSeriesProvider = StreamProvider<List<DownloadedItem>>((ref) {
  return _repo.watchDownloadedSeries(_activeServerId());
});

final downloadedEpisodesProvider =
    StreamProvider.family<List<DownloadedItem>, String>((ref, seriesId) {
  return _repo.watchSeriesEpisodes(seriesId, _activeServerId());
});

final downloadedSeasonEpisodesProvider =
    StreamProvider.family<List<DownloadedItem>, String>((ref, seasonId) {
  return _repo.watchSeasonEpisodes(seasonId, _activeServerId());
});

final storageUsedProvider = StreamProvider<int>((ref) {
  return _repo.watchTotalStorageUsed(_activeServerId());
});

final downloadedItemProvider =
    StreamProvider.family<DownloadedItem?, String>((ref, itemId) {
  return _repo.watchItem(itemId, _activeServerId());
});
