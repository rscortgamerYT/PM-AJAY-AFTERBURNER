import 'package:flutter/material.dart';

// Comprehensive Fund Flow Data Models
class FundFlowData {
  final List<SankeyNode> nodes;
  final List<SankeyLink> links;
  final double totalAllocated;
  final double totalUtilized;
  final double utilizationRate;
  final List<FundTransaction> recentTransactions;

  FundFlowData({
    required this.nodes,
    required this.links,
    required this.totalAllocated,
    required this.totalUtilized,
    required this.utilizationRate,
    required this.recentTransactions,
  });

  factory FundFlowData.fromJson(Map<String, dynamic> json) {
    return FundFlowData(
      nodes: (json['nodes'] as List? ?? [])
          .map((node) => SankeyNode.fromJson(node))
          .toList(),
      links: (json['links'] as List? ?? [])
          .map((link) => SankeyLink.fromJson(link))
          .toList(),
      totalAllocated: (json['total_allocated'] ?? 0).toDouble(),
      totalUtilized: (json['total_utilized'] ?? 0).toDouble(),
      utilizationRate: (json['utilization_rate'] ?? 0).toDouble(),
      recentTransactions: (json['recent_transactions'] as List? ?? [])
          .map((tx) => FundTransaction.fromJson(tx))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nodes': nodes.map((node) => node.toJson()).toList(),
      'links': links.map((link) => link.toJson()).toList(),
      'total_allocated': totalAllocated,
      'total_utilized': totalUtilized,
      'utilization_rate': utilizationRate,
      'recent_transactions': recentTransactions.map((tx) => tx.toJson()).toList(),
    };
  }
}

class SankeyNode {
  final String id;
  final String label;
  final NodeType type;
  final double value;
  final Color color;
  final Map<String, dynamic> metadata;
  final double x;
  final double y;
  final double height;

  SankeyNode({
    required this.id,
    required this.label,
    required this.type,
    required this.value,
    required this.color,
    required this.metadata,
    required this.x,
    required this.y,
    required this.height,
  });

  factory SankeyNode.fromJson(Map<String, dynamic> json) {
    return SankeyNode(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      type: NodeType.values.firstWhere(
        (type) => type.toString().split('.').last == json['type'],
        orElse: () => NodeType.centre,
      ),
      value: (json['value'] ?? 0).toDouble(),
      color: Color(int.parse(
        (json['color'] ?? '#3F51B5').substring(1, 7),
        radix: 16,
      ) + 0xFF000000),
      metadata: json['metadata'] ?? {},
      x: (json['x'] ?? 0).toDouble(),
      y: (json['y'] ?? 0).toDouble(),
      height: (json['height'] ?? 50).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'type': type.toString().split('.').last,
      'value': value,
      'color': '#${color.value.toRadixString(16).substring(2)}',
      'metadata': metadata,
      'x': x,
      'y': y,
      'height': height,
    };
  }

  SankeyNode copyWith({
    String? id,
    String? label,
    NodeType? type,
    double? value,
    Color? color,
    Map<String, dynamic>? metadata,
    double? x,
    double? y,
    double? height,
  }) {
    return SankeyNode(
      id: id ?? this.id,
      label: label ?? this.label,
      type: type ?? this.type,
      value: value ?? this.value,
      color: color ?? this.color,
      metadata: metadata ?? this.metadata,
      x: x ?? this.x,
      y: y ?? this.y,
      height: height ?? this.height,
    );
  }
}

class SankeyLink {
  final String sourceId;
  final String targetId;
  final double value;
  final Color color;
  final List<String> transactionIds;
  final LinkStatus status;

  SankeyLink({
    required this.sourceId,
    required this.targetId,
    required this.value,
    required this.color,
    required this.transactionIds,
    required this.status,
  });

  factory SankeyLink.fromJson(Map<String, dynamic> json) {
    return SankeyLink(
      sourceId: json['source_id'] ?? '',
      targetId: json['target_id'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
      color: Color(int.parse(
        (json['color'] ?? '#3F51B5').substring(1, 7),
        radix: 16,
      ) + 0xFF000000),
      transactionIds: List<String>.from(json['transaction_ids'] ?? []),
      status: LinkStatus.values.firstWhere(
        (status) => status.toString().split('.').last == json['status'],
        orElse: () => LinkStatus.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source_id': sourceId,
      'target_id': targetId,
      'value': value,
      'color': '#${color.value.toRadixString(16).substring(2)}',
      'transaction_ids': transactionIds,
      'status': status.toString().split('.').last,
    };
  }

  SankeyLink copyWith({
    String? sourceId,
    String? targetId,
    double? value,
    Color? color,
    List<String>? transactionIds,
    LinkStatus? status,
  }) {
    return SankeyLink(
      sourceId: sourceId ?? this.sourceId,
      targetId: targetId ?? this.targetId,
      value: value ?? this.value,
      color: color ?? this.color,
      transactionIds: transactionIds ?? this.transactionIds,
      status: status ?? this.status,
    );
  }
}

class FundTransaction {
  final String id;
  final double amount;
  final String sourceId;
  final String targetId;
  final String sourceLabel;
  final String targetLabel;
  final TransactionStatus status;
  final TransactionType type;
  final DateTime createdAt;
  final DateTime? completedAt;
  final Map<String, dynamic> metadata;

  FundTransaction({
    required this.id,
    required this.amount,
    required this.sourceId,
    required this.targetId,
    required this.sourceLabel,
    required this.targetLabel,
    required this.status,
    required this.type,
    required this.createdAt,
    this.completedAt,
    this.metadata = const {},
  });

  factory FundTransaction.fromJson(Map<String, dynamic> json) {
    return FundTransaction(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      sourceId: json['source_id'] ?? '',
      targetId: json['target_id'] ?? '',
      sourceLabel: json['source_label'] ?? '',
      targetLabel: json['target_label'] ?? '',
      status: TransactionStatus.values.firstWhere(
        (status) => status.toString().split('.').last == json['status'],
        orElse: () => TransactionStatus.pending,
      ),
      type: TransactionType.values.firstWhere(
        (type) => type.toString().split('.').last == json['type'],
        orElse: () => TransactionType.centreToState,
      ),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at'])
          : null,
      metadata: json['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'source_id': sourceId,
      'target_id': targetId,
      'source_label': sourceLabel,
      'target_label': targetLabel,
      'status': status.toString().split('.').last,
      'type': type.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }
}

// Geographic Fund Flow Models
class GeographicFundFlow {
  final String id;
  final String transferId;
  final GeoLocation location;
  final DateTime timestamp;
  final GeographicEventType eventType;
  final Map<String, dynamic> metadata;

  GeographicFundFlow({
    required this.id,
    required this.transferId,
    required this.location,
    required this.timestamp,
    required this.eventType,
    this.metadata = const {},
  });

  factory GeographicFundFlow.fromJson(Map<String, dynamic> json) {
    return GeographicFundFlow(
      id: json['id'] ?? '',
      transferId: json['transfer_id'] ?? '',
      location: GeoLocation.fromJson(json['location'] ?? {}),
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      eventType: GeographicEventType.values.firstWhere(
        (type) => type.toString().split('.').last == json['event_type'],
        orElse: () => GeographicEventType.initiated,
      ),
      metadata: json['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transfer_id': transferId,
      'location': location.toJson(),
      'timestamp': timestamp.toIso8601String(),
      'event_type': eventType.toString().split('.').last,
      'metadata': metadata,
    };
  }
}

class GeoLocation {
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? state;
  final String? country;

  GeoLocation({
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    this.state,
    this.country,
  });

  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    return GeoLocation(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
    };
  }
}

class ProjectGeofence {
  final String id;
  final String projectId;
  final List<GeoLocation> boundary;
  final GeofenceType geofenceType;
  final DateTime createdAt;
  final bool isActive;

  ProjectGeofence({
    required this.id,
    required this.projectId,
    required this.boundary,
    required this.geofenceType,
    required this.createdAt,
    this.isActive = true,
  });

  factory ProjectGeofence.fromJson(Map<String, dynamic> json) {
    return ProjectGeofence(
      id: json['id'] ?? '',
      projectId: json['project_id'] ?? '',
      boundary: (json['boundary'] as List? ?? [])
          .map((point) => GeoLocation.fromJson(point))
          .toList(),
      geofenceType: GeofenceType.values.firstWhere(
        (type) => type.toString().split('.').last == json['geofence_type'],
        orElse: () => GeofenceType.workArea,
      ),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'boundary': boundary.map((point) => point.toJson()).toList(),
      'geofence_type': geofenceType.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
      'is_active': isActive,
    };
  }
}

// Fund Flow Analytics Models
class FundFlowAnalytics {
  final String period;
  final double totalInflow;
  final double totalOutflow;
  final double utilizationRate;
  final List<FlowTrend> trends;
  final List<BottleneckAnalysis> bottlenecks;
  final Map<String, double> stateWiseDistribution;

  FundFlowAnalytics({
    required this.period,
    required this.totalInflow,
    required this.totalOutflow,
    required this.utilizationRate,
    required this.trends,
    required this.bottlenecks,
    required this.stateWiseDistribution,
  });

  factory FundFlowAnalytics.fromJson(Map<String, dynamic> json) {
    return FundFlowAnalytics(
      period: json['period'] ?? '',
      totalInflow: (json['total_inflow'] ?? 0).toDouble(),
      totalOutflow: (json['total_outflow'] ?? 0).toDouble(),
      utilizationRate: (json['utilization_rate'] ?? 0).toDouble(),
      trends: (json['trends'] as List? ?? [])
          .map((trend) => FlowTrend.fromJson(trend))
          .toList(),
      bottlenecks: (json['bottlenecks'] as List? ?? [])
          .map((bottleneck) => BottleneckAnalysis.fromJson(bottleneck))
          .toList(),
      stateWiseDistribution: Map<String, double>.from(
        json['state_wise_distribution'] ?? {},
      ),
    );
  }
}

class FlowTrend {
  final DateTime date;
  final double amount;
  final TrendType type;

  FlowTrend({
    required this.date,
    required this.amount,
    required this.type,
  });

  factory FlowTrend.fromJson(Map<String, dynamic> json) {
    return FlowTrend(
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      amount: (json['amount'] ?? 0).toDouble(),
      type: TrendType.values.firstWhere(
        (type) => type.toString().split('.').last == json['type'],
        orElse: () => TrendType.inflow,
      ),
    );
  }
}

class BottleneckAnalysis {
  final String nodeId;
  final String nodeLabel;
  final double delayDays;
  final double impactAmount;
  final String reason;
  final BottleneckSeverity severity;

  BottleneckAnalysis({
    required this.nodeId,
    required this.nodeLabel,
    required this.delayDays,
    required this.impactAmount,
    required this.reason,
    required this.severity,
  });

  factory BottleneckAnalysis.fromJson(Map<String, dynamic> json) {
    return BottleneckAnalysis(
      nodeId: json['node_id'] ?? '',
      nodeLabel: json['node_label'] ?? '',
      delayDays: (json['delay_days'] ?? 0).toDouble(),
      impactAmount: (json['impact_amount'] ?? 0).toDouble(),
      reason: json['reason'] ?? '',
      severity: BottleneckSeverity.values.firstWhere(
        (severity) => severity.toString().split('.').last == json['severity'],
        orElse: () => BottleneckSeverity.low,
      ),
    );
  }
}

// Enums
enum NodeType { centre, state, agency, project }
enum LinkStatus { pending, active, completed, flagged, audited }
enum TransactionStatus { pending, confirmed, completed, flagged }
enum TransactionType { centreToState, stateToAgency, agencyInternal }
enum GeographicEventType { initiated, inTransit, received, utilized }
enum GeofenceType { workArea, serviceArea, impactZone }
enum TrendType { inflow, outflow, utilization }
enum BottleneckSeverity { low, medium, high, critical }

// Cache Management Models
class FundFlowCacheEntry {
  final String key;
  final FundFlowData data;
  final DateTime cachedAt;
  final Duration ttl;

  FundFlowCacheEntry({
    required this.key,
    required this.data,
    required this.cachedAt,
    required this.ttl,
  });

  bool get isExpired {
    return DateTime.now().difference(cachedAt) > ttl;
  }
}

// Performance Monitoring Models
class FundFlowPerformanceMetrics {
  final Duration renderTime;
  final int nodeCount;
  final int linkCount;
  final double memoryUsage;
  final String userRole;
  final String level;

  FundFlowPerformanceMetrics({
    required this.renderTime,
    required this.nodeCount,
    required this.linkCount,
    required this.memoryUsage,
    required this.userRole,
    required this.level,
  });

  Map<String, dynamic> toAnalyticsEvent() {
    return {
      'render_time_ms': renderTime.inMilliseconds,
      'node_count': nodeCount,
      'link_count': linkCount,
      'memory_usage_mb': memoryUsage,
      'user_role': userRole,
      'level': level,
    };
  }
}
