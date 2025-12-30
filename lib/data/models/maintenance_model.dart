import 'package:flutter/material.dart';

class MaintenanceResponse {
  final String status;
  final String message;
  final String fileUsed;
  final String timestamp;
  final MaintenanceData data;

  MaintenanceResponse({
    required this.status,
    required this.message,
    required this.fileUsed,
    required this.timestamp,
    required this.data,
  });

  factory MaintenanceResponse.fromJson(Map<String, dynamic> json) {
    return MaintenanceResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      fileUsed: json['file_used'] ?? '',
      timestamp: json['timestamp'] ?? '',
      data: MaintenanceData.fromJson(json['data'] ?? {}),
    );
  }
}

class MaintenanceData {
  final List<TrainPriority> trainPriorities;
  final PriorityStatistics priorityStatistics;
  final SummaryByPriorityLevel summaryByPriorityLevel;
  final AnalysisMetadata analysisMetadata;
  final AnalysisDetails analysisDetails;

  MaintenanceData({
    required this.trainPriorities,
    required this.priorityStatistics,
    required this.summaryByPriorityLevel,
    required this.analysisMetadata,
    required this.analysisDetails,
  });

  factory MaintenanceData.fromJson(Map<String, dynamic> json) {
    return MaintenanceData(
      trainPriorities: (json['train_priorities'] as List<dynamic>? ?? [])
          .map((e) => TrainPriority.fromJson(e as Map<String, dynamic>))
          .toList(),
      priorityStatistics: PriorityStatistics.fromJson(
        json['priority_statistics'] ?? {},
      ),
      summaryByPriorityLevel: SummaryByPriorityLevel.fromJson(
        json['summary_by_priority_level'] ?? {},
      ),
      analysisMetadata: AnalysisMetadata.fromJson(
        json['analysis_metadata'] ?? {},
      ),
      analysisDetails: AnalysisDetails.fromJson(
        json['analysis_details'] ?? {},
      ),
    );
  }
}

class TrainPriority {
  final String trainId;
  final int priorityRank;
  final double finalScore;
  final double weightedScore;
  final ScoresBySheet scoresBySheet;
  final OriginalData? originalData;

  TrainPriority({
    required this.trainId,
    required this.priorityRank,
    required this.finalScore,
    required this.weightedScore,
    required this.scoresBySheet,
    this.originalData,
  });

  factory TrainPriority.fromJson(Map<String, dynamic> json) {
    return TrainPriority(
      trainId: json['train_id']?.toString() ?? '',
      priorityRank: json['priority_rank'] ?? 0,
      finalScore: (json['final_score'] ?? 0.0).toDouble(),
      weightedScore: (json['weighted_score'] ?? 0.0).toDouble(),
      scoresBySheet: ScoresBySheet.fromJson(
        json['scores_by_sheet'] ?? {},
      ),
      originalData: json['original_data'] != null
          ? OriginalData.fromJson(json['original_data'])
          : null,
    );
  }

  String get priorityLevel {
    // You may want to use thresholds from AnalysisDetails if available
    if (finalScore >= 0.8) return 'High';
    if (finalScore >= 0.2) return 'Medium';
    return 'Low';
  }

  Color get priorityColor {
    switch (priorityLevel) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }
}

class ScoresBySheet {
  final double branding;
  final double cleaning;
  final double fitness;
  final double geometry;
  final double jobCard;
  final double mileage;

  ScoresBySheet({
    required this.branding,
    required this.cleaning,
    required this.fitness,
    required this.geometry,
    required this.jobCard,
    required this.mileage,
  });

  factory ScoresBySheet.fromJson(Map<String, dynamic> json) {
    return ScoresBySheet(
      branding: (json['Branding'] ?? 0.0).toDouble(),
      cleaning: (json['Cleaning'] ?? 0.0).toDouble(),
      fitness: (json['Fitness'] ?? 0.0).toDouble(),
      geometry: (json['Geometry'] ?? 0.0).toDouble(),
      jobCard: (json['Job card'] ?? 0.0).toDouble(),
      mileage: (json['Mileage'] ?? 0.0).toDouble(),
    );
  }
}

class OriginalData {
  final BrandingData? branding;
  final CleaningData? cleaning;
  final FitnessData? fitness;
  final GeometryData? geometry;
  final JobCardData? jobCard;
  final MileageData? mileage;

  OriginalData({
    this.branding,
    this.cleaning,
    this.fitness,
    this.geometry,
    this.jobCard,
    this.mileage,
  });

  factory OriginalData.fromJson(Map<String, dynamic> json) {
    return OriginalData(
      branding: json['Branding'] != null
          ? BrandingData.fromJson(json['Branding'])
          : null,
      cleaning: json['Cleaning'] != null
          ? CleaningData.fromJson(json['Cleaning'])
          : null,
      fitness: json['Fitness'] != null
          ? FitnessData.fromJson(json['Fitness'])
          : null,
      geometry: json['Geometry'] != null
          ? GeometryData.fromJson(json['Geometry'])
          : null,
      jobCard: json['Job card'] != null
          ? JobCardData.fromJson(json['Job card'])
          : null,
      mileage: json['Mileage'] != null
          ? MileageData.fromJson(json['Mileage'])
          : null,
    );
  }
}

class BrandingData {
  final int trainId;
  final int penalty;
  final int remainingHours;
  final int revenue;

  BrandingData({
    required this.trainId,
    required this.penalty,
    required this.remainingHours,
    required this.revenue,
  });

  factory BrandingData.fromJson(Map<String, dynamic> json) {
    return BrandingData(
      trainId: json['Train id'] ?? 0,
      penalty: json['Penelty'] ?? 0,
      remainingHours: json['Remaining hours'] ?? 0,
      revenue: json['Revenue'] ?? 0,
    );
  }
}

class CleaningData {
  final int trainId;
  final int lastClean;

  CleaningData({
    required this.trainId,
    required this.lastClean,
  });

  factory CleaningData.fromJson(Map<String, dynamic> json) {
    return CleaningData(
      trainId: json['Train id'] ?? 0,
      lastClean: json['Last clean'] ?? 0,
    );
  }
}

class FitnessData {
  final int trainId;
  final int daysRemaining;

  FitnessData({
    required this.trainId,
    required this.daysRemaining,
  });

  factory FitnessData.fromJson(Map<String, dynamic> json) {
    return FitnessData(
      trainId: json['Train id'] ?? 0,
      daysRemaining: json['Days remaining '] ?? 0,
    );
  }
}

class GeometryData {
  final int trainId;
  final int distance;

  GeometryData({
    required this.trainId,
    required this.distance,
  });

  factory GeometryData.fromJson(Map<String, dynamic> json) {
    return GeometryData(
      trainId: json['Train id'] ?? 0,
      distance: json['Distance'] ?? 0,
    );
  }
}

class JobCardData {
  final int trainId;
  final int criticalJobs;
  final int nonCriticalJobs;

  JobCardData({
    required this.trainId,
    required this.criticalJobs,
    required this.nonCriticalJobs,
  });

  factory JobCardData.fromJson(Map<String, dynamic> json) {
    return JobCardData(
      trainId: json['Train id'] ?? 0,
      criticalJobs: json['Critical jobs'] ?? 0,
      nonCriticalJobs: json['Non critical jobs'] ?? 0,
    );
  }
}

class MileageData {
  final int trainId;
  final int dailyAvgRun;
  final int totalKm;
  final int variance;

  MileageData({
    required this.trainId,
    required this.dailyAvgRun,
    required this.totalKm,
    required this.variance,
  });

  factory MileageData.fromJson(Map<String, dynamic> json) {
    return MileageData(
      trainId: json['Train id'] ?? 0,
      dailyAvgRun: json['Daily Avg run'] ?? 0,
      totalKm: json['Total KM'] ?? 0,
      variance: json['Variance'] ?? 0,
    );
  }
}

class PriorityStatistics {
  final Map<String, int> distribution;
  final PrioritySummary summary;

  PriorityStatistics({
    required this.distribution,
    required this.summary,
  });

  factory PriorityStatistics.fromJson(Map<String, dynamic> json) {
    return PriorityStatistics(
      distribution: Map<String, int>.from(json['distribution'] ?? {}),
      summary: PrioritySummary.fromJson(json['summary'] ?? {}),
    );
  }
}

class PrioritySummary {
  final int highestPriority;
  final int lowestPriority;
  final double maxScore;
  final double minScore;
  final double meanScore;
  final double stdScore;

  PrioritySummary({
    required this.highestPriority,
    required this.lowestPriority,
    required this.maxScore,
    required this.minScore,
    required this.meanScore,
    required this.stdScore,
  });

  factory PrioritySummary.fromJson(Map<String, dynamic> json) {
    return PrioritySummary(
      highestPriority: json['highest_priority'] ?? 0,
      lowestPriority: json['lowest_priority'] ?? 0,
      maxScore: (json['max_score'] ?? 0.0).toDouble(),
      minScore: (json['min_score'] ?? 0.0).toDouble(),
      meanScore: (json['mean_score'] ?? 0.0).toDouble(),
      stdScore: (json['std_score'] ?? 0.0).toDouble(),
    );
  }
}

class SummaryByPriorityLevel {
  final List<TrainPriority> highPriority;
  final List<TrainPriority> mediumPriority;
  final List<TrainPriority> lowPriority;

  SummaryByPriorityLevel({
    required this.highPriority,
    required this.mediumPriority,
    required this.lowPriority,
  });

  factory SummaryByPriorityLevel.fromJson(Map<String, dynamic> json) {
    return SummaryByPriorityLevel(
      highPriority: (json['high_priority'] as List<dynamic>? ?? [])
          .map((e) => TrainPriority.fromJson(e as Map<String, dynamic>))
          .toList(),
      mediumPriority: (json['medium_priority'] as List<dynamic>? ?? [])
          .map((e) => TrainPriority.fromJson(e as Map<String, dynamic>))
          .toList(),
      lowPriority: (json['low_priority'] as List<dynamic>? ?? [])
          .map((e) => TrainPriority.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AnalysisMetadata {
  final String fileProcessed;
  final double processingTimeSeconds;
  final List<String> sheetsProcessed;
  final String timestamp;
  final int totalSheetsProcessed;
  final int totalTrains;

  AnalysisMetadata({
    required this.fileProcessed,
    required this.processingTimeSeconds,
    required this.sheetsProcessed,
    required this.timestamp,
    required this.totalSheetsProcessed,
    required this.totalTrains,
  });

  factory AnalysisMetadata.fromJson(Map<String, dynamic> json) {
    return AnalysisMetadata(
      fileProcessed: json['file_processed'] ?? '',
      processingTimeSeconds:
          (json['processing_time_seconds'] ?? 0.0).toDouble(),
      sheetsProcessed: List<String>.from(json['sheets_processed'] ?? []),
      timestamp: json['timestamp'] ?? '',
      totalSheetsProcessed: json['total_sheets_processed'] ?? 0,
      totalTrains: json['total_trains'] ?? 0,
    );
  }
}

// --- New Models for analysis_details ---

class AnalysisDetails {
  final FeatureMatching featureMatching;
  final FeatureWeightsUsed featureWeightsUsed;
  final ModelPerformance modelPerformance;
  final PriorityThresholds priorityThresholds;
  final ValidationSummary validationSummary;

  AnalysisDetails({
    required this.featureMatching,
    required this.featureWeightsUsed,
    required this.modelPerformance,
    required this.priorityThresholds,
    required this.validationSummary,
  });

  factory AnalysisDetails.fromJson(Map<String, dynamic> json) {
    return AnalysisDetails(
      featureMatching: FeatureMatching.fromJson(json['feature_matching'] ?? {}),
      featureWeightsUsed: FeatureWeightsUsed.fromJson(json['feature_weights_used'] ?? {}),
      modelPerformance: ModelPerformance.fromJson(json['model_performance'] ?? {}),
      priorityThresholds: PriorityThresholds.fromJson(json['priority_thresholds'] ?? {}),
      validationSummary: ValidationSummary.fromJson(json['validation_summary'] ?? {}),
    );
  }
}

class FeatureMatching {
  final Map<String, dynamic> branding;
  final Map<String, dynamic> cleaning;
  final Map<String, dynamic> fitness;
  final Map<String, dynamic> geometry;
  final Map<String, dynamic> jobCard;
  final Map<String, dynamic> mileage;

  FeatureMatching({
    required this.branding,
    required this.cleaning,
    required this.fitness,
    required this.geometry,
    required this.jobCard,
    required this.mileage,
  });

  factory FeatureMatching.fromJson(Map<String, dynamic> json) {
    return FeatureMatching(
      branding: Map<String, dynamic>.from(json['Branding'] ?? {}),
      cleaning: Map<String, dynamic>.from(json['Cleaning'] ?? {}),
      fitness: Map<String, dynamic>.from(json['Fitness'] ?? {}),
      geometry: Map<String, dynamic>.from(json['Geometry'] ?? {}),
      jobCard: Map<String, dynamic>.from(json['Job card'] ?? {}),
      mileage: Map<String, dynamic>.from(json['Mileage'] ?? {}),
    );
  }
}

class FeatureWeightsUsed {
  final Map<String, double> weights;

  FeatureWeightsUsed({required this.weights});

  factory FeatureWeightsUsed.fromJson(Map<String, dynamic> json) {
    return FeatureWeightsUsed(
      weights: json.map((k, v) => MapEntry(k, (v as num).toDouble())),
    );
  }
}

class ModelPerformance {
  final Map<String, Map<String, ModelPerformanceDetails>> performance;

  ModelPerformance({required this.performance});

  factory ModelPerformance.fromJson(Map<String, dynamic> json) {
    final Map<String, Map<String, ModelPerformanceDetails>> perf = {};
    json.forEach((sheet, models) {
      perf[sheet] = {};
      (models as Map<String, dynamic>).forEach((model, details) {
        perf[sheet]![model] = ModelPerformanceDetails.fromJson(details);
      });
    });
    return ModelPerformance(performance: perf);
  }
}

class ModelPerformanceDetails {
  final double combinedScore;
  final double mae;
  final double mse;
  final double pearson;
  final List<double> predictions;
  final double r2;
  final double spearman;

  ModelPerformanceDetails({
    required this.combinedScore,
    required this.mae,
    required this.mse,
    required this.pearson,
    required this.predictions,
    required this.r2,
    required this.spearman,
  });

  factory ModelPerformanceDetails.fromJson(Map<String, dynamic> json) {
    return ModelPerformanceDetails(
      combinedScore: (json['combined_score'] ?? 0.0).toDouble(),
      mae: (json['mae'] ?? 0.0).toDouble(),
      mse: (json['mse'] ?? 0.0).toDouble(),
      pearson: (json['pearson'] ?? 0.0).toDouble(),
      predictions: (json['predictions'] as List<dynamic>? ?? []).map((e) => (e as num).toDouble()).toList(),
      r2: (json['r2'] ?? 0.0).toDouble(),
      spearman: (json['spearman'] ?? 0.0).toDouble(),
    );
  }
}

class PriorityThresholds {
  final double high;
  final double medium;
  final double low;

  PriorityThresholds({
    required this.high,
    required this.medium,
    required this.low,
  });

  factory PriorityThresholds.fromJson(Map<String, dynamic> json) {
    return PriorityThresholds(
      high: (json['high'] ?? 0.8).toDouble(),
      medium: (json['medium'] ?? 0.5).toDouble(),
      low: (json['low'] ?? 0.2).toDouble(),
    );
  }
}

class ValidationSummary {
  final Map<String, ValidationDetails> summary;

  ValidationSummary({required this.summary});

  factory ValidationSummary.fromJson(Map<String, dynamic> json) {
    final Map<String, ValidationDetails> map = {};
    json.forEach((k, v) {
      map[k] = ValidationDetails.fromJson(v);
    });
    return ValidationSummary(summary: map);
  }
}

class ValidationDetails {
  final bool isValid;
  final List<dynamic> issues;
  final List<dynamic> warnings;

  ValidationDetails({
    required this.isValid,
    required this.issues,
    required this.warnings,
  });

  factory ValidationDetails.fromJson(Map<String, dynamic> json) {
    return ValidationDetails(
      isValid: json['is_valid'] ?? true,
      issues: List<dynamic>.from(json['issues'] ?? []),
      warnings: List<dynamic>.from(json['warnings'] ?? []),
    );
  }
}
