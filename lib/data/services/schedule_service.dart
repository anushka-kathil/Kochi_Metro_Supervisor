import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kochi_metro_supervisor/core/constants/app_constants.dart';
import 'package:kochi_metro_supervisor/data/models/schedule_model.dart';



// Service

class ScheduleService {
 
  final http.Client httpClient;

  ScheduleService({ http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

 final String baseUrl= AppConstants.baseUrl;
  Future<RunningTrainsResponse> getRunningTrains({
    required String time,
    String? station,
    String? trainId,
  }) async {
    final uri = Uri.parse('$baseUrl/api/trains/running').replace(
      queryParameters: {
        'time': time,
        if (station != null) 'station': station,
        if (trainId != null) 'train_id': trainId,
      },
    );

    final response = await httpClient.get(uri);

    if (response.statusCode == 200) {
      return RunningTrainsResponse.fromJson(json.decode(response.body));
    } else {
      // Try to parse error message
      try {
        final jsonBody = json.decode(response.body);
        return RunningTrainsResponse(
          status: 'error',
          error: jsonBody['error'] ?? 'Unknown error',
        );
      } catch (_) {
        return RunningTrainsResponse(
          status: 'error',
          error: 'Failed to fetch running trains',
        );
      }
    }
  }
}


extension ScheduleServiceGenerate on ScheduleService {
  Future<GenerateScheduleResponse> generateSchedule({
    required int availableSlots,
  }) async {
    final uri = Uri.parse('$baseUrl/api/schedule/generate');
    final response = await httpClient.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'available_slots': availableSlots}),
    );

    if (response.statusCode == 200) {
      return GenerateScheduleResponse.fromJson(json.decode(response.body));
    } else {
      try {
        final jsonBody = json.decode(response.body);
        return GenerateScheduleResponse(
          message: jsonBody['message'] ?? 'Unknown error',
          status: jsonBody['status'] ?? 'error',
        );
      } catch (_) {
        return GenerateScheduleResponse(
          message: 'Failed to generate schedule',
          status: 'error',
        );
      }
    }
  }
}