import 'dart:convert';
import 'package:diary/domain/entities/call_to_action.dart';
import 'package:diary/domain/entities/call_to_action_response.dart';
import 'package:diary/utils/logger.dart';
import 'package:http/http.dart' as http;
import '../../keys.dart';

abstract class CallToActionRemoteDataSources {
  Future<CallToActionResponse> sendData(CallToAction callToAction);
}

class CallToActionRemoteDataSourcesImpl extends CallToActionRemoteDataSources {
  @override
  Future<CallToActionResponse> sendData(CallToAction callToAction) async {
    final map = callToAction.toJson();
    final response = await http.post('https://arianna.digit.srl/api/check',
        body: json.encode(map),
        headers: <String, String>{
          'Diary-Key': diaryKey,
          'Content-Type': 'application/json',
        });
    final statusCode = response.statusCode;
    logger.i('$statusCode - ${response.body}');
    if (statusCode == 200) {
      logger.i(response.body);
      final map = json.decode(response.body);
      return CallToActionResponse.fromJson(map);
    }

    logger.e('$statusCode - ${response.body}');
    throw Exception('$statusCode - ${response.body}');
  }
}
