import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../data/models/schedule_model.dart';
import 'dashboard_controller.dart';

class WhatIfController extends GetxController {
  // Observable variables for train counts
  final RxInt totalTrains = 0.obs;
  final RxInt runningTrains = 0.obs;
  final RxInt maintenanceTrains = 0.obs;
  final RxInt cleaningTrains = 0.obs;
  final RxInt revenueOperationTrains = 0.obs;
  final RxInt standbyTrains = 0.obs;

  // Simulation state
  final RxBool isSimulating = false.obs;
  final RxBool hasResults = false.obs;
  final RxString errorMessage = ''.obs;

  // Results
  final RxList<ScheduleItem> scheduleResults = <ScheduleItem>[].obs;
  final Rx<GenerateScheduleResponse?> simulationResponse =
      Rx<GenerateScheduleResponse?>(null);

  @override
  void onInit() {
    super.onInit();
    _initializeFromDashboard();
  }

  void _initializeFromDashboard() {
    try {
      // Get dashboard controller data
      final dashboardController = Get.find<DashboardController>();

      // Initialize with dashboard values
      totalTrains.value = 31; // Total fleet size
      runningTrains.value = dashboardController.availableTrains.value;
      maintenanceTrains.value = dashboardController.maintenanceTrains.value;
      cleaningTrains.value = 3; // From dashboard status
      revenueOperationTrains.value = 1; // From dashboard status
      standbyTrains.value = 4; // From dashboard status

      _validateTotals();
    } catch (e) {
      // Fallback values if dashboard controller not found
      totalTrains.value = 31;
      runningTrains.value = 25;
      maintenanceTrains.value = 6;
      cleaningTrains.value = 3;
      revenueOperationTrains.value = 1;
      standbyTrains.value = 4;
    }
  }

  // Computed property for allocated trains
  int get allocatedTrains =>
      runningTrains.value +
      maintenanceTrains.value +
      cleaningTrains.value +
      revenueOperationTrains.value +
      standbyTrains.value;

  // Computed property for remaining trains
  int get remainingTrains => totalTrains.value - allocatedTrains;

  // Validation
  bool get isValid => allocatedTrains <= totalTrains.value;

  void _validateTotals() {
    if (allocatedTrains > totalTrains.value) {
      // Auto-adjust to prevent exceeding total
      final excess = allocatedTrains - totalTrains.value;
      _reduceTrainsProportionally(excess);
    }
  }

  void _reduceTrainsProportionally(int excess) {
    // Reduce from largest categories first
    final categories = [
      {'value': runningTrains, 'priority': 1},
      {'value': standbyTrains, 'priority': 2},
      {'value': maintenanceTrains, 'priority': 3},
      {'value': cleaningTrains, 'priority': 4},
      {'value': revenueOperationTrains, 'priority': 5},
    ];

    categories.sort((a, b) =>
        (b['value'] as RxInt).value.compareTo((a['value'] as RxInt).value));

    int remaining = excess;
    for (var category in categories) {
      final rxInt = category['value'] as RxInt;
      final reduction = (rxInt.value > remaining) ? remaining : rxInt.value;
      rxInt.value = (rxInt.value - reduction).clamp(0, rxInt.value);
      remaining -= reduction;
      if (remaining <= 0) break;
    }
  }

  // Increment/Decrement methods
  void incrementRunning() {
    if (allocatedTrains < totalTrains.value) {
      runningTrains.value++;
    } else {
      _showValidationError();
    }
  }

  void decrementRunning() {
    if (runningTrains.value > 0) {
      runningTrains.value--;
    }
  }

  void incrementMaintenance() {
    if (allocatedTrains < totalTrains.value) {
      maintenanceTrains.value++;
    } else {
      _showValidationError();
    }
  }

  void decrementMaintenance() {
    if (maintenanceTrains.value > 0) {
      maintenanceTrains.value--;
    }
  }

  void incrementCleaning() {
    if (allocatedTrains < totalTrains.value) {
      cleaningTrains.value++;
    } else {
      _showValidationError();
    }
  }

  void decrementCleaning() {
    if (cleaningTrains.value > 0) {
      cleaningTrains.value--;
    }
  }

  void incrementRevenueOperation() {
    if (allocatedTrains < totalTrains.value) {
      revenueOperationTrains.value++;
    } else {
      _showValidationError();
    }
  }

  void decrementRevenueOperation() {
    if (revenueOperationTrains.value > 0) {
      revenueOperationTrains.value--;
    }
  }

  void incrementStandby() {
    if (allocatedTrains < totalTrains.value) {
      standbyTrains.value++;
    } else {
      _showValidationError();
    }
  }

  void decrementStandby() {
    if (standbyTrains.value > 0) {
      standbyTrains.value--;
    }
  }

  void _showValidationError() {
    Get.snackbar(
      'Cannot Exceed Total',
      'The sum of all categories cannot exceed total trains (${totalTrains.value})',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  // Reset to dashboard values
  void resetToDefaults() {
    _initializeFromDashboard();
    hasResults.value = false;
    errorMessage.value = '';
    scheduleResults.clear();
  }

  // Run simulation API call
  Future<void> runSimulation() async {
    if (!isValid) {
      _showValidationError();
      return;
    }

    try {
      isSimulating.value = true;
      errorMessage.value = '';
      hasResults.value = false;
      int slots = maintenanceTrains.value +
          cleaningTrains.value +
          revenueOperationTrains.value +
          standbyTrains.value;
      ;

      print("trains : ${allocatedTrains.toString()}");
      print("slots : ${slots.toString()}");
      final response = await http.post(
        Uri.parse(
            'https://kochi-metro-backend.onrender.com/api/schedule/generate'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'available_slots': slots,
          'available_trains': allocatedTrains,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        simulationResponse.value =
            GenerateScheduleResponse.fromJson(responseData);

        // Convert response to schedule items for display
        _processScheduleResults();

        hasResults.value = true;

        Get.snackbar(
          'Simulation Complete',
          'Schedule generated successfully with ${scheduleResults.length} items',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF00D2A3),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = 'Failed to generate schedule: ${e.toString()}';
      Get.snackbar(
        'Simulation Failed',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isSimulating.value = false;
    }
  }

  void _processScheduleResults() {
    scheduleResults.clear();

    final response = simulationResponse.value;
    if (response?.data?.schedule != null) {
      final schedule = response!.data!.schedule;

      // Convert the schedule map to ScheduleItem list
      schedule.forEach((timeSlot, trainIds) {
        for (String trainId in trainIds) {
          scheduleResults.add(ScheduleItem(
            trainId: trainId,
            timeSlot: timeSlot,
            status: 'Scheduled',
            route: 'Route A', // Default route
            startTime: _generateTimeFromSlot(timeSlot, true),
            endTime: _generateTimeFromSlot(timeSlot, false),
          ));
        }
      });
    }
  }

  String _generateTimeFromSlot(String timeSlot, bool isStart) {
    // Generate realistic times based on slot
    final slots = {
      'morning': isStart ? '06:00' : '12:00',
      'afternoon': isStart ? '12:00' : '18:00',
      'evening': isStart ? '18:00' : '23:00',
      'night': isStart ? '23:00' : '06:00',
    };

    return slots[timeSlot.toLowerCase()] ?? (isStart ? '06:00' : '18:00');
  }
}

// Model for schedule display
class ScheduleItem {
  final String trainId;
  final String timeSlot;
  final String status;
  final String route;
  final String startTime;
  final String endTime;

  ScheduleItem({
    required this.trainId,
    required this.timeSlot,
    required this.status,
    required this.route,
    required this.startTime,
    required this.endTime,
  });
}
