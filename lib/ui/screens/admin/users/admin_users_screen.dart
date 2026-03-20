import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:server_core/server_core.dart';

import '../../../navigation/destinations.dart';
import '../providers/admin_user_providers.dart';
import 'admin_user_delete_dialog.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(adminUsersListProvider);
    final client = GetIt.instance<MediaServerClient>();

    return usersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Failed to load users',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('$e', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () => ref.invalidate(adminUsersListProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (users) {
        final filtered = users.where((user) {
          if (_searchQuery.isEmpty) {
            return true;
          }
          final query = _searchQuery.toLowerCase();
          return (user.name ?? '').toLowerCase().contains(query);
        }).toList();

        return Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value.trim()),
                  decoration: InputDecoration(
                    hintText: 'Search users',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                            icon: const Icon(Icons.clear),
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filtered.isEmpty
            ? Center(
                child: Text(
                  users.isEmpty ? 'No users found' : 'No users match your search',
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final user = filtered[index];
                  final isAdmin =
                      user.policy?.isAdministrator ?? false;
                  final isDisabled = user.policy?.isDisabled ?? false;

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: user.primaryImageTag != null
                            ? NetworkImage(
                                client.imageApi.getUserImageUrl(user.id))
                            : null,
                        child: user.primaryImageTag == null
                            ? Text(
                                (user.name ?? '?')[0].toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )
                            : null,
                      ),
                      title: Row(
                        children: [
                          Flexible(
                            child: Text(
                              user.name ?? 'Unknown',
                              style: TextStyle(
                                decoration: isDisabled
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: isDisabled
                                    ? Theme.of(context).disabledColor
                                    : null,
                              ),
                            ),
                          ),
                          if (isAdmin) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.shield,
                                size: 16,
                                color:
                                    Theme.of(context).colorScheme.primary),
                          ],
                          if (isDisabled) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.block,
                                size: 16,
                                color: Theme.of(context).colorScheme.error),
                          ],
                        ],
                      ),
                      subtitle: Text(
                        user.hasPassword ? 'Password set' : 'No password',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              context
                                  .go(Destinations.adminUser(user.id));
                            case 'delete':
                              showAdminUserDeleteDialog(
                                context,
                                user: user,
                                onDeleted: () =>
                                    ref.invalidate(adminUsersListProvider),
                              );
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: 'edit',
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Edit'),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                      onTap: () =>
                          context.push(Destinations.adminUser(user.id)),
                    ),
                  );
                },
              ),
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton.extended(
              onPressed: () => context.push(Destinations.adminUsersAdd),
              icon: const Icon(Icons.person_add),
              label: const Text('Add User'),
            ),
          ),
        ],
      );
      },
    );
  }
}
