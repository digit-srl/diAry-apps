import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:diary/core/errors/exceptions.dart';
import 'package:diary/domain/entities/daily_stats.dart';
import 'package:diary/domain/entities/daily_stats_response.dart';
import '../../keys.dart';

abstract class DailyStatsRemoteDataSources {
  Future<DailyStatsResponse> sendDailyStats(DailyStats s);
}

class DailyStatsRemoteDataSourcesImpl extends DailyStatsRemoteDataSources {
  @override
  Future<DailyStatsResponse> sendDailyStats(DailyStats stats) async {
    final map = stats.toJson();
    final response = await http.post('https://arianna.digit.srl/api/upload',
        body: json.encode(map),
        headers: <String, String>{
          'Diary-Key': diaryKey,
          'Content-Type': 'application/json',
        });
    final statusCode = response.statusCode;
    print('$statusCode - ${response.body}');
    if (statusCode == 200) {
      print(response.body);
      final map = json.decode(response.body);
      return DailyStatsResponse.fromJson(map);
    } else if (statusCode == 409) {
      throw ConflictDay();
    } else if (statusCode == 422) {
      throw UnprocessableEntity();
    }
    print('$statusCode - ${response.body}');
    throw Exception('$statusCode - ${response.body}');
  }
}
