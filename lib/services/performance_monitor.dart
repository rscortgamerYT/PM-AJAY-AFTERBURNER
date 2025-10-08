import 'dart:async';
import 'dart:io';
import '../models/fund_flow/fund_flow_models.dart';

// Performance Monitoring System for Map & Fund Flow
class MapPerformanceMonitor {
  static final Map<String, DateTime> _operationStartTimes = {};
  static final List<PerformanceMetric> _metrics = [];
  static const int _maxMetricsHistory = 1000;

  // Track map interaction performance
  static void trackMapInteraction(
    String action,
    Map<String, dynamic> metadata,
  ) {
    final metric = PerformanceMetric(
      type: PerformanceType.mapInteraction,
      action: action,
      timestamp: DateTime.now(),
      metadata: metadata,
    );
    
    _addMetric(metric);
    _logToAnalytics('map_interaction', metadata);
  }

  // Track fund flow rendering performance
  static void trackFundFlowRendering(
    Duration renderTime,
    int nodeCount,
    int linkCount, {
    String? userRole,
    String? level,
  }) {
    final metric = PerformanceMetric(
      type: PerformanceType.fundFlowRender,
      action: 'render_sankey',
      timestamp: DateTime.now(),
      duration: renderTime,
      metadata: {
        'node_count': nodeCount,
        'link_count': linkCount,
        'user_role': userRole,
        'level': level,
        'render_time_ms': renderTime.inMilliseconds,
      },
    );
    
    _addMetric(metric);
    _logToAnalytics('fund_flow_render', metric.metadata);
    
    // Alert if rendering is slow
    if (renderTime.inMilliseconds > 2000) {
      _alertSlowPerformance('fund_flow_render', renderTime, metric.metadata);
    }
  }

  // Start timing an operation
  static void startOperation(String operationId) {
    _operationStartTimes[operationId] = DateTime.now();
  }

  // End timing an operation
  static Duration? endOperation(String operationId) {
    final startTime = _operationStartTimes.remove(operationId);
    if (startTime != null) {
      return DateTime.now().difference(startTime);
    }
    return null;
  }

  // Track data loading performance
  static void trackDataLoad(
    String dataType,
    Duration loadTime,
    int recordCount, {
    bool fromCache = false,
    Map<String, dynamic>? additionalMetadata,
  }) {
    final metadata = {
      'data_type': dataType,
      'load_time_ms': loadTime.inMilliseconds,
      'record_count': recordCount,
      'from_cache': fromCache,
      'records_per_second': recordCount / (loadTime.inMilliseconds / 1000),
      ...?additionalMetadata,
    };

    final metric = PerformanceMetric(
      type: PerformanceType.dataLoad,
      action: 'load_$dataType',
      timestamp: DateTime.now(),
      duration: loadTime,
      metadata: metadata,
    );
    
    _addMetric(metric);
    _logToAnalytics('data_load', metadata);
  }

  // Track memory usage
  static Future<void> trackMemoryUsage(String context) async {
    try {
      final processInfo = ProcessInfo.currentRss;
      final memoryMB = processInfo / (1024 * 1024);
      
      final metric = PerformanceMetric(
        type: PerformanceType.memoryUsage,
        action: 'memory_check',
        timestamp: DateTime.now(),
        metadata: {
          'context': context,
          'memory_mb': memoryMB,
          'memory_bytes': processInfo,
        },
      );
      
      _addMetric(metric);
      
      // Alert if memory usage is high
      if (memoryMB > 500) {
        _alertHighMemoryUsage(context, memoryMB);
      }
    } catch (e) {
      print('Error tracking memory usage: $e');
    }
  }

  // Track user interaction patterns
  static void trackUserInteraction(
    String interactionType,
    String component,
    Map<String, dynamic> details,
  ) {
    final metric = PerformanceMetric(
      type: PerformanceType.userInteraction,
      action: interactionType,
      timestamp: DateTime.now(),
      metadata: {
        'component': component,
        'interaction_type': interactionType,
        ...details,
      },
    );
    
    _addMetric(metric);
    _logToAnalytics('user_interaction', metric.metadata);
  }

  // Get performance summary
  static PerformanceSummary getPerformanceSummary({
    Duration? timeWindow,
  }) {
    final cutoffTime = timeWindow != null 
        ? DateTime.now().subtract(timeWindow)
        : DateTime.now().subtract(const Duration(hours: 1));
    
    final recentMetrics = _metrics
        .where((m) => m.timestamp.isAfter(cutoffTime))
        .toList();

    return PerformanceSummary(
      totalInteractions: recentMetrics.length,
      averageRenderTime: _calculateAverageRenderTime(recentMetrics),
      averageLoadTime: _calculateAverageLoadTime(recentMetrics),
      memoryUsageTrend: _calculateMemoryTrend(recentMetrics),
      slowOperations: _findSlowOperations(recentMetrics),
      errorRate: _calculateErrorRate(recentMetrics),
      cacheHitRate: _calculateCacheHitRate(recentMetrics),
    );
  }

  // Get detailed metrics for analysis
  static List<PerformanceMetric> getMetrics({
    PerformanceType? type,
    Duration? timeWindow,
    int? limit,
  }) {
    var filteredMetrics = _metrics.asMap().entries.map((e) => e.value).toList();
    
    if (type != null) {
      filteredMetrics = filteredMetrics.where((m) => m.type == type).toList();
    }
    
    if (timeWindow != null) {
      final cutoffTime = DateTime.now().subtract(timeWindow);
      filteredMetrics = filteredMetrics.where((m) => m.timestamp.isAfter(cutoffTime)).toList();
    }
    
    // Sort by timestamp (most recent first)
    filteredMetrics.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    if (limit != null && filteredMetrics.length > limit) {
      filteredMetrics = filteredMetrics.take(limit).toList();
    }
    
    return filteredMetrics;
  }

  // Export performance data
  static Map<String, dynamic> exportPerformanceData() {
    final summary = getPerformanceSummary();
    final recentMetrics = getMetrics(limit: 100);
    
    return {
      'summary': summary.toJson(),
      'recent_metrics': recentMetrics.map((m) => m.toJson()).toList(),
      'export_timestamp': DateTime.now().toIso8601String(),
      'total_metrics_collected': _metrics.length,
    };
  }

  // Clear old metrics to prevent memory leaks
  static void cleanupOldMetrics() {
    if (_metrics.length > _maxMetricsHistory) {
      final excessCount = _metrics.length - _maxMetricsHistory;
      _metrics.removeRange(0, excessCount);
    }
    
    // Remove metrics older than 24 hours
    final cutoffTime = DateTime.now().subtract(const Duration(hours: 24));
    _metrics.removeWhere((m) => m.timestamp.isBefore(cutoffTime));
  }

  // Private helper methods
  static void _addMetric(PerformanceMetric metric) {
    _metrics.add(metric);
    
    // Periodic cleanup
    if (_metrics.length % 100 == 0) {
      cleanupOldMetrics();
    }
  }

  static void _logToAnalytics(String eventName, Map<String, dynamic> parameters) {
    // In a real implementation, this would send to Firebase Analytics or similar
    print('Analytics Event: $eventName - $parameters');
  }

  static void _alertSlowPerformance(
    String operation,
    Duration duration,
    Map<String, dynamic> metadata,
  ) {
    print('PERFORMANCE ALERT: Slow $operation - ${duration.inMilliseconds}ms');
    print('Metadata: $metadata');
    
    // In production, this could trigger alerts to monitoring systems
  }

  static void _alertHighMemoryUsage(String context, double memoryMB) {
    print('MEMORY ALERT: High usage in $context - ${memoryMB.toStringAsFixed(1)}MB');
    
    // In production, this could trigger memory optimization routines
  }

  static Duration _calculateAverageRenderTime(List<PerformanceMetric> metrics) {
    final renderMetrics = metrics
        .where((m) => m.type == PerformanceType.fundFlowRender && m.duration != null)
        .toList();
    
    if (renderMetrics.isEmpty) return Duration.zero;
    
    final totalMs = renderMetrics
        .map((m) => m.duration!.inMilliseconds)
        .reduce((a, b) => a + b);
    
    return Duration(milliseconds: (totalMs / renderMetrics.length).round());
  }

  static Duration _calculateAverageLoadTime(List<PerformanceMetric> metrics) {
    final loadMetrics = metrics
        .where((m) => m.type == PerformanceType.dataLoad && m.duration != null)
        .toList();
    
    if (loadMetrics.isEmpty) return Duration.zero;
    
    final totalMs = loadMetrics
        .map((m) => m.duration!.inMilliseconds)
        .reduce((a, b) => a + b);
    
    return Duration(milliseconds: (totalMs / loadMetrics.length).round());
  }

  static List<double> _calculateMemoryTrend(List<PerformanceMetric> metrics) {
    return metrics
        .where((m) => m.type == PerformanceType.memoryUsage)
        .map((m) => (m.metadata['memory_mb'] as num?)?.toDouble() ?? 0.0)
        .toList();
  }

  static List<PerformanceMetric> _findSlowOperations(List<PerformanceMetric> metrics) {
    return metrics
        .where((m) => m.duration != null && m.duration!.inMilliseconds > 1000)
        .toList();
  }

  static double _calculateErrorRate(List<PerformanceMetric> metrics) {
    if (metrics.isEmpty) return 0.0;
    
    final errorCount = metrics
        .where((m) => m.metadata['error'] == true)
        .length;
    
    return errorCount / metrics.length;
  }

  static double _calculateCacheHitRate(List<PerformanceMetric> metrics) {
    final loadMetrics = metrics
        .where((m) => m.type == PerformanceType.dataLoad)
        .toList();
    
    if (loadMetrics.isEmpty) return 0.0;
    
    final cacheHits = loadMetrics
        .where((m) => m.metadata['from_cache'] == true)
        .length;
    
    return cacheHits / loadMetrics.length;
  }
}

// Performance Metric Model
class PerformanceMetric {
  final PerformanceType type;
  final String action;
  final DateTime timestamp;
  final Duration? duration;
  final Map<String, dynamic> metadata;

  PerformanceMetric({
    required this.type,
    required this.action,
    required this.timestamp,
    this.duration,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'action': action,
      'timestamp': timestamp.toIso8601String(),
      'duration_ms': duration?.inMilliseconds,
      'metadata': metadata,
    };
  }
}

// Performance Summary Model
class PerformanceSummary {
  final int totalInteractions;
  final Duration averageRenderTime;
  final Duration averageLoadTime;
  final List<double> memoryUsageTrend;
  final List<PerformanceMetric> slowOperations;
  final double errorRate;
  final double cacheHitRate;

  PerformanceSummary({
    required this.totalInteractions,
    required this.averageRenderTime,
    required this.averageLoadTime,
    required this.memoryUsageTrend,
    required this.slowOperations,
    required this.errorRate,
    required this.cacheHitRate,
  });

  Map<String, dynamic> toJson() {
    return {
      'total_interactions': totalInteractions,
      'average_render_time_ms': averageRenderTime.inMilliseconds,
      'average_load_time_ms': averageLoadTime.inMilliseconds,
      'memory_usage_trend': memoryUsageTrend,
      'slow_operations_count': slowOperations.length,
      'error_rate': errorRate,
      'cache_hit_rate': cacheHitRate,
    };
  }
}

// Performance Types Enum
enum PerformanceType {
  mapInteraction,
  fundFlowRender,
  dataLoad,
  memoryUsage,
  userInteraction,
}
