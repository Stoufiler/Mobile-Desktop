class AggregatedItem {
  final String id;
  final String serverId;
  final Map<String, dynamic> rawData;

  const AggregatedItem({
    required this.id,
    required this.serverId,
    required this.rawData,
  });

  String get name => rawData['Name'] as String? ?? '';
  String? get type => rawData['Type'] as String?;
  String? get seriesName => rawData['SeriesName'] as String?;
  int? get productionYear => rawData['ProductionYear'] as int?;
  double? get communityRating => rawData['CommunityRating'] as double?;
  String? get overview => rawData['Overview'] as String?;
  String? get officialRating => rawData['OfficialRating'] as String?;
  int? get indexNumber => rawData['IndexNumber'] as int?;
  int? get parentIndexNumber => rawData['ParentIndexNumber'] as int?;

  int? get runTimeTicks => rawData['RunTimeTicks'] as int?;
  Duration? get runtime => runTimeTicks != null
      ? Duration(microseconds: runTimeTicks! ~/ 10)
      : null;

  List<String> get genres =>
      (rawData['Genres'] as List?)?.cast<String>() ?? const [];

  String? get primaryImageTag =>
      (rawData['ImageTags'] as Map?)?['Primary'] as String?;

  List<String> get backdropImageTags =>
      (rawData['BackdropImageTags'] as List?)?.cast<String>() ?? const [];

  String? get parentBackdropItemId =>
      rawData['ParentBackdropItemId'] as String?;

  List<String> get parentBackdropImageTags =>
      (rawData['ParentBackdropImageTags'] as List?)?.cast<String>() ?? const [];

  String? get logoImageTag =>
      (rawData['ImageTags'] as Map?)?['Logo'] as String?;

  Map? get _userData => rawData['UserData'] as Map?;

  double? get playedPercentage =>
      _userData?['PlayedPercentage'] as double?;

  bool get isPlayed =>
      _userData?['Played'] as bool? ?? false;

  bool get isFavorite =>
      _userData?['IsFavorite'] as bool? ?? false;

  int? get unplayedItemCount =>
      _userData?['UnplayedItemCount'] as int?;

  String get displayTitle {
    if (type == 'Episode') {
      final series = seriesName ?? '';
      final s = parentIndexNumber;
      final e = indexNumber;
      if (series.isNotEmpty && s != null && e != null) {
        return '$series - S${s}E$e - $name';
      }
    }
    return name;
  }
}
