import 'package:get/get.dart';

// Import for Get and Widget
import 'package:flutter/material.dart';

import '../../data/models/maintenance_model.dart';
import '../../domain/usecases/maintenance_usecase.dart';

class MaintenanceController extends GetxController {
  final MaintenanceUseCase _useCase;

  MaintenanceController(this._useCase);

  // Observables
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _maintenanceData = Rxn<MaintenanceResponse>();
  final _filteredTrains = <TrainPriority>[].obs;
  final _selectedPriorityLevel = 'All'.obs;
  final _searchQuery = ''.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  MaintenanceResponse? get maintenanceData => _maintenanceData.value;
  List<TrainPriority> get filteredTrains => _filteredTrains.toList();
  String get selectedPriorityLevel => _selectedPriorityLevel.value;
  String get searchQuery => _searchQuery.value;

  // Computed properties
  List<TrainPriority> get allTrains {
    return maintenanceData?.data.trainPriorities ?? [];
  }

  int get totalTrains {
    return maintenanceData?.data.analysisMetadata.totalTrains ?? 0;
  }

  int get highPriorityCount {
    return _getCount("High");
  }

  int get mediumPriorityCount {
    return _getCount("Medium");
  }

  int get lowPriorityCount {
    return _getCount("Low");
  }

  List<String> get priorityLevels => ['All', 'High', 'Medium', 'Low'];

  @override
  void onInit() {
    super.onInit();
    loadMaintenanceData();
  }

  Future<void> loadMaintenanceData() async {
    try {
      print('DEBUG: Starting loadMaintenanceData');
      _isLoading.value = true;
      _errorMessage.value = '';

      print('DEBUG: About to call useCase.execute()');
      final response = await _useCase.execute();
      print('DEBUG: Got response: $response');

      _maintenanceData.value = response;
      print('DEBUG: Set maintenance data');

      // Initialize filtered trains with all trains
      _applyFilters();
      print(
          'DEBUG: Applied filters, total filtered trains: ${_filteredTrains.length}');
    } catch (e) {
      print('DEBUG: Error occurred: ${e.toString()}');
      print('DEBUG: Error type: ${e.runtimeType}');
      _errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load maintenance data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      print('DEBUG: Setting isLoading to false');
      _isLoading.value = false;
      print('DEBUG: isLoading is now: ${_isLoading.value}');
    }
  }

  Future<void> refreshData() async {
    await loadMaintenanceData();
  }

  void setPriorityFilter(String level) {
    _selectedPriorityLevel.value = level;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
    _applyFilters();
  }

  void clearFilters() {
    _selectedPriorityLevel.value = 'All';
    _searchQuery.value = '';
    _applyFilters();
  }

  void _applyFilters() {
    var trains = List<TrainPriority>.from(allTrains);

    // Sort by priority rank
    trains = _useCase.sortTrainsByPriority(trains);

    // Apply priority level filter
    if (_selectedPriorityLevel.value != 'All') {
      trains = _useCase.filterTrainsByPriorityLevel(
        trains,
        _selectedPriorityLevel.value,
      );
    }

    // Apply search filter
    if (_searchQuery.value.isNotEmpty) {
      trains = _useCase.searchTrains(trains, _searchQuery.value);
    }

    _filteredTrains.value = trains;
  }

  int _getCount(String query) {
    var trains = List<TrainPriority>.from(allTrains);

    // Sort by priority rank
    trains = _useCase.sortTrainsByPriority(trains);

    // Apply search filter

    trains = _useCase.searchTrains(trains, query);

    return trains.length;
  }

  TrainPriority? getTrainById(String trainId) {
    try {
      return allTrains.firstWhere((train) => train.trainId == trainId);
    } catch (e) {
      return null;
    }
  }

  String getFormattedScore(double score) {
    return (score * 100).toStringAsFixed(1);
  }

  String getFormattedTimestamp() {
    if (maintenanceData?.timestamp.isEmpty ?? true) return 'N/A';

    try {
      final dateTime = DateTime.parse(maintenanceData!.timestamp);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  void showTrainDetails(TrainPriority train) {
    Get.bottomSheet(
      _buildTrainDetailSheet(train),
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Widget _buildTrainDetailSheet(TrainPriority train) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Train ${train.trainId}',
                    style: Get.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: train.priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: train.priorityColor),
                    ),
                    child: Text(
                      '${train.priorityLevel} Priority',
                      style: TextStyle(
                        color: train.priorityColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Scores
              Text(
                'Maintenance Scores',
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              _buildScoreRow('Priority Rank', train.priorityRank.toString()),
              _buildScoreRow(
                  'Final Score', '${getFormattedScore(train.finalScore)}%'),
              _buildScoreRow('Weighted Score',
                  '${getFormattedScore(train.weightedScore)}%'),

              const Divider(height: 18),

              // Component Scores
              // Text(
              //   'Component Scores',
              //   style: Get.textTheme.titleMedium?.copyWith(
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // const SizedBox(height: 10),
              //
              // _buildScoreRow('Branding',
              //     '${getFormattedScore(train.scoresBySheet.branding)}%'),
              // _buildScoreRow('Job Card',
              //     '${getFormattedScore(train.scoresBySheet.jobCard)}%'),
              // _buildScoreRow('Cleaning',
              //     '${getFormattedScore(train.scoresBySheet.cleaning)}%'),
              // _buildScoreRow('Fitness',
              //     '${getFormattedScore(train.scoresBySheet.fitness)}%'),
              // _buildScoreRow('Geometry',
              //     '${getFormattedScore(train.scoresBySheet.geometry)}%'),
              // _buildScoreRow('Mileage',
              //     '${getFormattedScore(train.scoresBySheet.mileage)}%'),

              const SizedBox(height: 10),

              // Original Data Section (if available)
              ...[
                Text(
                  'Original Data',
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _buildOriginalDataSection(train.originalData!),
              ],

              // const SizedBox(height: 12),

              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'Close',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildOriginalDataSection(OriginalData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (data.branding != null) ...[
          _buildScoreRow('Revenue', '₹${data.branding!.revenue}'),
          _buildScoreRow('Penalty', '₹${data.branding!.penalty}'),
          _buildScoreRow(
              'Remaining Hours', '${data.branding!.remainingHours}h'),
        ],
        if (data.jobCard != null) ...[
          _buildScoreRow('Critical Jobs', '${data.jobCard!.criticalJobs}'),
          _buildScoreRow(
              'Non-Critical Jobs', '${data.jobCard!.nonCriticalJobs}'),
        ],
        if (data.cleaning != null)
          _buildScoreRow('Last Clean', '${data.cleaning!.lastClean} days ago'),
        if (data.fitness != null)
          _buildScoreRow(
              'Fitness Days Remaining', '${data.fitness!.daysRemaining}'),
        if (data.geometry != null)
          _buildScoreRow('Distance', '${data.geometry!.distance} km'),
        if (data.mileage != null) ...[
          _buildScoreRow('Total KM', '${data.mileage!.totalKm}'),
          _buildScoreRow('Daily Avg Run', '${data.mileage!.dailyAvgRun} km'),
          _buildScoreRow('Variance', '${data.mileage!.variance}'),
        ],
      ],
    );
  }
}
