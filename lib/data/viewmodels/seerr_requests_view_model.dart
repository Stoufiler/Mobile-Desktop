import 'package:flutter/foundation.dart';

import '../repositories/seerr_repository.dart';
import '../services/seerr/seerr_api_models.dart';

class SeerrRequestsState {
  final bool isLoading;
  final bool isRefreshing;
  final String? error;
  final List<SeerrRequest> requests;

  const SeerrRequestsState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
    this.requests = const [],
  });
}

class SeerrRequestsViewModel extends ChangeNotifier {
  final SeerrRepository _repo;

  SeerrRequestsState _state = const SeerrRequestsState();
  SeerrRequestsState get state => _state;

  SeerrRequestsViewModel(this._repo);

  Future<void> load({bool isRefresh = false}) async {
    _state = SeerrRequestsState(
      isLoading: !isRefresh,
      isRefreshing: isRefresh,
      requests: isRefresh ? _state.requests : const [],
    );
    notifyListeners();

    try {
      await _repo.ensureInitialized();
      final user = await _repo.getCurrentUser();
      final response = await _repo.getRequests(requestedBy: user.id);

      final now = DateTime.now();
      final filtered = response.results.where((r) {
        if (r.status == SeerrRequest.statusDeclined) {
          final updated = r.updatedAt != null
              ? DateTime.tryParse(r.updatedAt!)
              : null;
          if (updated != null && now.difference(updated).inDays > 3) {
            return false;
          }
        }
        return true;
      }).toList();

      _state = SeerrRequestsState(requests: filtered);
    } catch (e) {
      _state = SeerrRequestsState(error: e.toString());
    }
    notifyListeners();
  }

  Future<void> refresh() => load(isRefresh: true);
}
