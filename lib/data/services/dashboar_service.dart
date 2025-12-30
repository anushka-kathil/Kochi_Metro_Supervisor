import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kochi_metro_supervisor/core/constants/app_constants.dart';
import 'package:kochi_metro_supervisor/data/models/dashboard_model.dart';

class DashboardService {
  DashboardService();

  final String baseUrl = AppConstants.baseUrl;

  Future<DashboardOverview> fetchDashboardOverview() async {
    final response = await http.get(Uri.parse('$baseUrl/api/dashboard'));

    if (response.statusCode == 200) {
      return DashboardOverview.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load dashboard data');
    }
  }
}
