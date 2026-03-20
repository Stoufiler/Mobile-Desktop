import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:server_core/server_core.dart';

import 'admin_user_providers.dart';

class AdminNotificationSummary {
  final bool hasPluginUpdates;
  final bool hasFailedTasks;
  final bool hasAlerts;

  const AdminNotificationSummary({
    this.hasPluginUpdates = false,
    this.hasFailedTasks = false,
    this.hasAlerts = false,
  });

  int get count =>
      (hasPluginUpdates ? 1 : 0) +
      (hasFailedTasks ? 1 : 0) +
      (hasAlerts ? 1 : 0);
}

final adminNotificationSummaryProvider =
    FutureProvider<AdminNotificationSummary>((ref) async {
  final client = GetIt.instance<MediaServerClient>();

  try {
    final results = await Future.wait<dynamic>([
      ref.watch(adminInstalledPluginsProvider.future),
      ref.watch(adminAvailablePackagesProvider.future),
      ref.watch(adminTasksProvider.future),
      client.adminSystemApi.getActivityLog(limit: 20),
    ]);

    final installed = results[0] as List<PluginInfo>;
    final available = results[1] as List<PackageInfo>;
    final tasks = results[2] as List<TaskInfo>;
    final activity = results[3] as ActivityLogResult;

    final availableById = {
      for (final package in available)
        if (package.id.isNotEmpty) package.id: package,
    };

    final hasPluginUpdates = installed.any((plugin) {
      final package = availableById[plugin.id];
      if (package == null || plugin.version.isEmpty) {
        return false;
      }
      return package.versions.any((version) => version.version != plugin.version);
    });

    final hasFailedTasks = tasks.any(
      (task) => task.lastExecutionResult?.status == 'Failed',
    );

    final hasAlerts = activity.items.any(
      (entry) => entry.severity == 'Error' || entry.severity == 'Warning' || entry.severity == 'Warn',
    );

    return AdminNotificationSummary(
      hasPluginUpdates: hasPluginUpdates,
      hasFailedTasks: hasFailedTasks,
      hasAlerts: hasAlerts,
    );
  } catch (_) {
    return const AdminNotificationSummary();
  }
});