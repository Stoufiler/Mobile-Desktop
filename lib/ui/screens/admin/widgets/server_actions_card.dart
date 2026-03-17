import 'package:flutter/material.dart';
import 'package:server_core/server_core.dart';

class ServerActionsCard extends StatelessWidget {
  final MediaServerClient client;
  final bool canSelfRestart;
  final VoidCallback onActionComplete;

  const ServerActionsCard({
    super.key,
    required this.client,
    required this.canSelfRestart,
    required this.onActionComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.settings_power, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text('Server Actions', style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (canSelfRestart)
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Restart Server'),
                    onPressed: () => _confirmAction(
                      context,
                      title: 'Restart Server',
                      message: 'Are you sure you want to restart the server?',
                      onConfirm: () async {
                        await client.adminSystemApi.restartServer();
                        if (!context.mounted) return;
                        await _waitForServer(context);
                        onActionComplete();
                      },
                    ),
                  ),
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.power_settings_new),
                  label: const Text('Shutdown Server'),
                  onPressed: () => _confirmAction(
                    context,
                    title: 'Shutdown Server',
                    message: 'Are you sure you want to shut down the server? You will need to restart it manually.',
                    onConfirm: () async {
                      await client.adminSystemApi.shutdownServer();
                    },
                  ),
                ),
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Scan Libraries'),
                  onPressed: () async {
                    try {
                      await client.adminLibraryApi.refreshLibrary();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Library scan started')),
                        );
                      }
                      onActionComplete();
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _waitForServer(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 24),
              Expanded(child: Text('Server is restarting...')),
            ],
          ),
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 3));

    for (var i = 0; i < 60; i++) {
      try {
        await client.systemApi.getSystemInfo();
        if (context.mounted) Navigator.of(context).pop();
        return;
      } catch (_) {
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    if (context.mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Server did not respond after restart')),
      );
    }
  }

  Future<void> _confirmAction(
    BuildContext context, {
    required String title,
    required String message,
    required Future<void> Function() onConfirm,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      try {
        await onConfirm();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }
}
