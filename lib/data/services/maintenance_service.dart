import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kochi_metro_supervisor/core/constants/app_constants.dart';

import '../models/maintenance_model.dart';

class MaintenanceService {
  static const String _baseUrl = AppConstants.baseUrl;

  Future<MaintenanceResponse> fetchMaintenanceData() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/priority/analyze'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(
            "high on service : ${jsonData['data']['summary_by_priority_level']['high_priority'].length.toString()}");
        return MaintenanceResponse.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load maintenance data. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Error fetching maintenance data: ${e.toString()}');
    }
  }
}
