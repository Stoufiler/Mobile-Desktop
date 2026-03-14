import 'package:dio/dio.dart';
import 'package:server_core/server_core.dart';

class JellyfinLiveTvApi implements LiveTvApi {
  final Dio _dio;

  JellyfinLiveTvApi(this._dio);

  @override
  Future<Map<String, dynamic>> getChannels({
    int? startIndex,
    int? limit,
    String? sortBy,
    String? sortOrder,
    String? fields,
    bool? enableTotalRecordCount,
  }) async {
    final response = await _dio.get('/LiveTv/Channels', queryParameters: {
      if (startIndex != null) 'StartIndex': startIndex,
      if (limit != null) 'Limit': limit,
      if (sortBy != null) 'SortBy': sortBy,
      if (sortOrder != null) 'SortOrder': sortOrder,
      if (fields != null) 'Fields': fields,
      if (enableTotalRecordCount != null) 'EnableTotalRecordCount': enableTotalRecordCount,
    });
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getGuide({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? channelIds,
    String? fields,
    bool? enableTotalRecordCount,
  }) async {
    final response = await _dio.get('/LiveTv/Programs', queryParameters: {
      if (startDate != null) 'MinStartDate': startDate.toIso8601String(),
      if (endDate != null) 'MaxEndDate': endDate.toIso8601String(),
      if (channelIds != null && channelIds.isNotEmpty) 'ChannelIds': channelIds.join(','),
      if (fields != null) 'Fields': fields,
      if (enableTotalRecordCount != null) 'EnableTotalRecordCount': enableTotalRecordCount,
    });
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getRecommendedPrograms({int? limit}) async {
    final response = await _dio.get(
      '/LiveTv/Programs/Recommended',
      queryParameters: {if (limit != null) 'Limit': limit},
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getRecordings() async {
    final response = await _dio.get('/LiveTv/Recordings');
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getTimers() async {
    final response = await _dio.get('/LiveTv/Timers');
    return response.data as Map<String, dynamic>;
  }
}
