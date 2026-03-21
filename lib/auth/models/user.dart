sealed class User {
  String get id;
  String get name;
  String get serverId;
  String? get imageTag;
  bool get isAdministrator;
  bool get canDownload;

  const User();
}

class PrivateUser extends User {
  @override
  final String id;
  @override
  final String name;
  @override
  final String serverId;
  final String accessToken;
  final DateTime lastUsed;
  @override
  final String? imageTag;
  @override
  final bool isAdministrator;
  @override
  final bool canDownload;

  const PrivateUser({
    required this.id,
    required this.name,
    required this.serverId,
    required this.accessToken,
    required this.lastUsed,
    this.imageTag,
    this.isAdministrator = false,
    this.canDownload = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'accessToken': accessToken,
        'lastUsed': lastUsed.toIso8601String(),
        'imageTag': imageTag,
        'isAdministrator': isAdministrator,
        'canDownload': canDownload,
      };

  factory PrivateUser.fromJson(
    String id,
    String serverId,
    Map<String, dynamic> json,
  ) {
    return PrivateUser(
      id: id,
      name: json['name'] as String? ?? '',
      serverId: serverId,
      accessToken: json['accessToken'] as String? ?? '',
      lastUsed: DateTime.tryParse(json['lastUsed'] as String? ?? '') ??
          DateTime.now(),
      imageTag: json['imageTag'] as String?,
      isAdministrator: json['isAdministrator'] as bool? ?? false,
      canDownload: json['canDownload'] as bool? ?? false,
    );
  }

  PrivateUser copyWith({
    String? id,
    String? name,
    String? serverId,
    String? accessToken,
    DateTime? lastUsed,
    String? imageTag,
    bool? isAdministrator,
    bool? canDownload,
  }) {
    return PrivateUser(
      id: id ?? this.id,
      name: name ?? this.name,
      serverId: serverId ?? this.serverId,
      accessToken: accessToken ?? this.accessToken,
      lastUsed: lastUsed ?? this.lastUsed,
      imageTag: imageTag ?? this.imageTag,
      isAdministrator: isAdministrator ?? this.isAdministrator,
      canDownload: canDownload ?? this.canDownload,
    );
  }
}

class PublicUser extends User {
  @override
  final String id;
  @override
  final String name;
  @override
  final String serverId;
  final bool hasPassword;
  @override
  final String? imageTag;
  @override
  final bool isAdministrator;
  @override
  final bool canDownload;

  const PublicUser({
    required this.id,
    required this.name,
    required this.serverId,
    required this.hasPassword,
    this.imageTag,
    this.isAdministrator = false,
    this.canDownload = false,
  });
}
