import 'package:get/get.dart';
import 'package:kochi_metro_supervisor/domain/repositories/schedule_repository.dart';
import 'package:kochi_metro_supervisor/domain/usecases/schedule_usecase.dart';
import 'dart:developer' as developer;

import '../../data/models/schedule_model.dart';

class ScheduleController extends GetxController {
  final isLoading = false.obs;
  final schedules = <RunningTrain>[].obs;
  RxString trainid = ''.obs;
  RxString staion = ''.obs;
  var time = DateTime.now().obs;
  RxString selectedTimeFilter = 'Afternoon (12 PM - 6 PM)'.obs;
  late final ScheduleRepository repository;
  late final GetRunningTrainsUseCase getRunningTrainsUseCase;
  late final GenerateScheduleUseCase generateScheduleUseCase;

  @override
  void onInit() {
    super.onInit();
    repository = Get.find<ScheduleRepository>();
    getRunningTrainsUseCase = GetRunningTrainsUseCase(repository);
    generateScheduleUseCase = GenerateScheduleUseCase(repository);

    // Set current time as default and load initial schedules
    setDefaultCurrentTime();
    _loadSchedules(
        trainId: trainid.value.isEmpty ? null : trainid.value,
        station: staion.value.isEmpty ? null : staion.value,
        time: time.value);
  }

  Future<void> _loadSchedules(
      {String? trainId, String? station, required DateTime time}) async {
    isLoading.value = true;
    try {
      final now = time;
      // Only one of trainId or station should be provided
      String? id;
      String? st;
      if (trainId != null &&
          trainId.isNotEmpty &&
          (station == null || station.isEmpty)) {
        id = trainId;
      } else if (station != null &&
          station.isNotEmpty &&
          (trainId == null || trainId.isEmpty)) {
        st = station;
      }
      final response = await getRunningTrainsUseCase(
        time:
            "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
        trainId: id,
        station: st,
      );
      // Ensure response.data and runningTrains are not null
      if (response.data?.runningTrains != null) {
        final trains = response.data!.runningTrains!;

        // Sort the trains by trainId before assigning
        _sortTrainsByTrainId(trains);
        schedules.assignAll(trains);
      } else {
        schedules.clear();
        developer.log('No running trains found or response data is null',
            name: 'ScheduleController');
      }
    } catch (e, stackTrace) {
      developer.log('Error loading schedules: ${e.toString()}',
          name: 'ScheduleController', error: e, stackTrace: stackTrace);
      schedules.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Sort trains by train ID
  void _sortTrainsByTrainId(List<RunningTrain> trains) {
    trains.sort((a, b) {
      // Handle null train IDs by placing them at the end
      if (a.trainId == null && b.trainId == null) return 0;
      if (a.trainId == null) return 1;
      if (b.trainId == null) return -1;

      // Natural sort for train IDs (handles numeric sorting properly)
      return _naturalSort(a.trainId!, b.trainId!);
    });
  }

  // Natural sort function for proper numeric sorting of train IDs
  int _naturalSort(String a, String b) {
    // Extract numeric parts and compare them numerically
    final aMatch = RegExp(r'(\d+)').firstMatch(a);
    final bMatch = RegExp(r'(\d+)').firstMatch(b);

    if (aMatch != null && bMatch != null) {
      final aNum = int.tryParse(aMatch.group(0)!);
      final bNum = int.tryParse(bMatch.group(0)!);

      if (aNum != null && bNum != null) {
        final numComparison = aNum.compareTo(bNum);
        if (numComparison != 0) return numComparison;
      }
    }

    // Fallback to string comparison
    return a.compareTo(b);
  }

  // Set current time as default time filter
  void setDefaultCurrentTime() {
    final now = DateTime.now();
    time.value = DateTime(now.year, now.month, now.day, 15);
    selectedTimeFilter.value = _getCurrentTimeLabel();
  }

  // Get current time label based on current hour
  String _getCurrentTimeLabel() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      return 'Morning (6 AM - 12 PM)';
    } else if (hour >= 18 && hour < 24) {
      return 'Evening (6 PM - 12 AM)';
    } else {
      return 'Afternoon (12 PM - 6 PM)';
    }
  }

  // Get unique station options from schedules
  List<String> getStationOptions() {
    List<String> stations = [
      "ALVA",
      "PNCU",
      "CPPY",
      "ATTK",
      "MUTT",
      "KLMT",
      "CCUV",
      "PDPM",
      "EDAP",
      "CGPP",
      "PARV",
      "JLSD",
      "KALR",
      "TNHL",
      "MGRD",
      "MACE",
      "ERSH",
      "KVTR",
      "EMKM",
      "VYTA",
      "THYK",
      "PETT",
      "VAKK",
      "SNJN",
      "TPHT"
    ];
    return stations;
  }

  // Get unique train ID options from schedules
  List<String> getTrainIdOptions() {
    Set<String> trainIds = {};
    for (var schedule in schedules) {
      if (schedule.trainId != null) {
        trainIds.add(schedule.trainId!);
      }
    }
    List<String> trainIdList = trainIds.toList();

    // Sort train IDs naturally
    trainIdList.sort((a, b) => _naturalSort(a, b));

    // Add clear option at the beginning
    trainIdList.insert(0, 'Clear Selection');
    return trainIdList;
  }

  // Get time filter options
  List<String> getTimeOptions() {
    return [
      'Morning (6 AM - 12 PM)',
      'Afternoon (12 PM - 6 PM)',
      'Evening (6 PM - 12 AM)',
    ];
  }

  // Get selected time label for display (compulsory field)
  String getSelectedTimeLabel() {
    return selectedTimeFilter.value.isEmpty
        ? _getCurrentTimeLabel()
        : selectedTimeFilter.value;
  }

  // Set time filter based on selection (compulsory)
  void setTimeFilter(String timeLabel) {
    selectedTimeFilter.value = timeLabel;

    final now = DateTime.now();

    switch (timeLabel) {
      case 'Morning (6 AM - 12 PM)':
        time.value =
            DateTime(now.year, now.month, now.day, 9); // 9 AM as representative
        break;
      case 'Afternoon (12 PM - 6 PM)':
        time.value = DateTime(
            now.year, now.month, now.day, 15); // 3 PM as representative
        break;
      case 'Evening (6 PM - 12 AM)':
        time.value = DateTime(
            now.year, now.month, now.day, 21); // 9 PM as representative
        break;
    }
    // Apply filters after time change
    applyFilters();
  }

  // Apply filters by reloading data with current filter values
  void applyFilters() {
    // Ensure only one of station or trainId is set
    if (staion.value.isNotEmpty && trainid.value.isNotEmpty) {
      trainid.value = ''; // Clear trainId if both are set
    }

    _loadSchedules(
      trainId: trainid.value.isEmpty ? null : trainid.value,
      station: staion.value.isEmpty ? null : staion.value,
      time: time.value,
    );
  }

  // Clear all filters and reload
  void clearFilters() {
    trainid.value = '';
    staion.value = '';
    setDefaultCurrentTime();
    applyFilters();
  }

  // Handle station selection
  void selectStation(String? station) {
    if (station == 'Clear Selection' || station == null) {
      staion.value = '';
    } else {
      staion.value = station;
      if (station.isNotEmpty) {
        trainid.value = ''; // Clear train ID when station is selected
      }
    }
    applyFilters();
  }

  // Handle train ID selection
  void selectTrainId(String? trainId) {
    if (trainId == 'Clear Selection' || trainId == null) {
      trainid.value = '';
    } else {
      trainid.value = trainId;
      if (trainId.isNotEmpty) {
        staion.value = ''; // Clear station when train ID is selected
      }
    }
    applyFilters();
  }

  // Refresh data
  Future<void> refreshData() async {
    await _loadSchedules(
      trainId: trainid.value.isEmpty ? null : trainid.value,
      station: staion.value.isEmpty ? null : staion.value,
      time: time.value,
    );
  }
}
