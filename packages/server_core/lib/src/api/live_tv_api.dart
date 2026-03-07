abstract class LiveTvApi {
  Future<Map<String, dynamic>> getChannels({
    int? startIndex,
    int? limit,
  });

  Future<Map<String, dynamic>> getGuide({
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Map<String, dynamic>> getRecommendedPrograms({int? limit});
  Future<Map<String, dynamic>> getRecordings();
  Future<Map<String, dynamic>> getTimers();
}
