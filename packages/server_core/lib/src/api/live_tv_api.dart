abstract class LiveTvApi {
  Future<Map<String, dynamic>> getChannels({
    int? startIndex,
    int? limit,
    String? sortBy,
    String? sortOrder,
    String? fields,
    bool? enableTotalRecordCount,
  });

  Future<Map<String, dynamic>> getGuide({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? channelIds,
    String? fields,
    bool? enableTotalRecordCount,
  });

  Future<Map<String, dynamic>> getRecommendedPrograms({int? limit});
  Future<Map<String, dynamic>> getRecordings();
  Future<Map<String, dynamic>> getTimers();
}
