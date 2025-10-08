import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Offline-First Data Synchronization Service
class OfflineFirstService {
  static final OfflineFirstService _instance = OfflineFirstService._internal();
  factory OfflineFirstService() => _instance;
  OfflineFirstService._internal();

  // Simulated local cache (in real app, would use Hive/SQLite)
  final Map<String, dynamic> _localCache = {};
  final List<OfflineAction> _pendingActions = [];
  bool _isOnline = true;
  
  // Listeners for connectivity changes
  final List<VoidCallback> _connectivityListeners = [];

  // Initialize the service
  Future<void> initialize() async {
    await _loadCachedData();
    await _loadPendingActions();
    _startConnectivityMonitoring();
  }

  // Check if device is online
  Future<bool> get isOnline async {
    try {
      final result = await InternetAddress.lookup('google.com');
      _isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      _isOnline = false;
    }
    return _isOnline;
  }

  // Get projects with offline-first approach
  Future<List<ProjectData>> getProjects({bool forceOnline = false}) async {
    final cacheKey = 'projects';
    
    if (await isOnline || forceOnline) {
      try {
        // Simulate API call
        final onlineData = await _fetchProjectsFromAPI();
        await _cacheData(cacheKey, onlineData);
        await _syncPendingActions();
        return onlineData;
      } catch (e) {
        debugPrint('Failed to fetch online data: $e');
        return _getCachedProjects(cacheKey);
      }
    } else {
      return _getCachedProjects(cacheKey);
    }
  }

  // Submit evidence with offline support
  Future<void> submitEvidence({
    required String projectId,
    required String photoPath,
    required String description,
    required String location,
  }) async {
    final action = OfflineAction(
      id: 'evidence_${DateTime.now().millisecondsSinceEpoch}',
      type: ActionType.submitEvidence,
      data: {
        'project_id': projectId,
        'photo_path': photoPath,
        'description': description,
        'location': location,
        'timestamp': DateTime.now().toIso8601String(),
        'user_id': 'current_user_id',
      },
      timestamp: DateTime.now(),
      retryCount: 0,
    );

    if (await isOnline) {
      try {
        await _executeAction(action);
        _showSuccessNotification('Evidence submitted successfully');
      } catch (e) {
        await _queueOfflineAction(action);
        _showOfflineNotification('Evidence queued for upload when online');
      }
    } else {
      await _queueOfflineAction(action);
      _showOfflineNotification('Evidence saved offline. Will sync when connected.');
    }
  }

  // Submit fund request with offline support
  Future<void> submitFundRequest({
    required String stateCode,
    required double amount,
    required String purpose,
    required List<String> documents,
  }) async {
    final action = OfflineAction(
      id: 'fund_request_${DateTime.now().millisecondsSinceEpoch}',
      type: ActionType.submitFundRequest,
      data: {
        'state_code': stateCode,
        'amount': amount,
        'purpose': purpose,
        'documents': documents,
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'pending',
      },
      timestamp: DateTime.now(),
      retryCount: 0,
    );

    if (await isOnline) {
      try {
        await _executeAction(action);
        _showSuccessNotification('Fund request submitted successfully');
      } catch (e) {
        await _queueOfflineAction(action);
        _showOfflineNotification('Fund request queued for submission');
      }
    } else {
      await _queueOfflineAction(action);
      _showOfflineNotification('Fund request saved offline. Will submit when connected.');
    }
  }

  // Update project status with offline support
  Future<void> updateProjectStatus({
    required String projectId,
    required String newStatus,
    required String comments,
  }) async {
    final action = OfflineAction(
      id: 'status_update_${DateTime.now().millisecondsSinceEpoch}',
      type: ActionType.updateProjectStatus,
      data: {
        'project_id': projectId,
        'new_status': newStatus,
        'comments': comments,
        'timestamp': DateTime.now().toIso8601String(),
        'updated_by': 'current_user_id',
      },
      timestamp: DateTime.now(),
      retryCount: 0,
    );

    if (await isOnline) {
      try {
        await _executeAction(action);
        _showSuccessNotification('Project status updated successfully');
      } catch (e) {
        await _queueOfflineAction(action);
        _showOfflineNotification('Status update queued for sync');
      }
    } else {
      await _queueOfflineAction(action);
      _showOfflineNotification('Status update saved offline. Will sync when connected.');
    }
  }

  // Get cached data with fallback
  List<ProjectData> _getCachedProjects(String key) {
    final cachedData = _localCache[key] as List<dynamic>?;
    if (cachedData != null) {
      return cachedData.map((json) => ProjectData.fromJson(json)).toList();
    }
    return _getDefaultProjects();
  }

  // Default projects for offline mode
  List<ProjectData> _getDefaultProjects() {
    return [
      ProjectData(
        id: 'offline_1',
        title: 'Rural Infrastructure Development',
        description: 'Improving rural connectivity and infrastructure',
        status: 'Active',
        progress: 0.65,
        budgetAllocated: 50000000,
        budgetUtilized: 32500000,
        state: 'Maharashtra',
        startDate: DateTime.now().subtract(const Duration(days: 180)),
        endDate: DateTime.now().add(const Duration(days: 185)),
        isOfflineData: true,
      ),
      ProjectData(
        id: 'offline_2',
        title: 'Education Facility Upgrade',
        description: 'Modernizing educational infrastructure',
        status: 'In Progress',
        progress: 0.40,
        budgetAllocated: 30000000,
        budgetUtilized: 12000000,
        state: 'Karnataka',
        startDate: DateTime.now().subtract(const Duration(days: 90)),
        endDate: DateTime.now().add(const Duration(days: 275)),
        isOfflineData: true,
      ),
    ];
  }

  // Simulate API call
  Future<List<ProjectData>> _fetchProjectsFromAPI() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    // Simulate API response
    return [
      ProjectData(
        id: 'api_1',
        title: 'Smart City Initiative',
        description: 'Digital transformation of urban infrastructure',
        status: 'Active',
        progress: 0.75,
        budgetAllocated: 100000000,
        budgetUtilized: 75000000,
        state: 'Tamil Nadu',
        startDate: DateTime.now().subtract(const Duration(days: 200)),
        endDate: DateTime.now().add(const Duration(days: 165)),
        isOfflineData: false,
      ),
      ProjectData(
        id: 'api_2',
        title: 'Healthcare Infrastructure',
        description: 'Building modern healthcare facilities',
        status: 'Planning',
        progress: 0.20,
        budgetAllocated: 80000000,
        budgetUtilized: 16000000,
        state: 'Gujarat',
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now().add(const Duration(days: 335)),
        isOfflineData: false,
      ),
    ];
  }

  // Cache data locally
  Future<void> _cacheData(String key, List<ProjectData> data) async {
    _localCache[key] = data.map((project) => project.toJson()).toList();
    await _saveCacheToStorage();
  }

  // Queue offline action
  Future<void> _queueOfflineAction(OfflineAction action) async {
    _pendingActions.add(action);
    await _savePendingActions();
  }

  // Execute action (submit to server)
  Future<void> _executeAction(OfflineAction action) async {
    switch (action.type) {
      case ActionType.submitEvidence:
        await _submitEvidenceToAPI(action.data);
        break;
      case ActionType.submitFundRequest:
        await _submitFundRequestToAPI(action.data);
        break;
      case ActionType.updateProjectStatus:
        await _updateProjectStatusAPI(action.data);
        break;
    }
  }

  // Simulate API calls
  Future<void> _submitEvidenceToAPI(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('Evidence submitted to API: ${data['project_id']}');
  }

  Future<void> _submitFundRequestToAPI(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('Fund request submitted to API: ${data['amount']}');
  }

  Future<void> _updateProjectStatusAPI(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('Project status updated via API: ${data['project_id']}');
  }

  // Background sync when connection restored
  Future<void> _syncPendingActions() async {
    final actionsToRemove = <OfflineAction>[];
    
    for (final action in _pendingActions) {
      try {
        await _executeAction(action);
        actionsToRemove.add(action);
        _showSyncNotification('Synced: ${action.type.name}');
      } catch (e) {
        action.retryCount++;
        if (action.retryCount >= 3) {
          // Max retries reached, remove from queue
          actionsToRemove.add(action);
          _showErrorNotification('Failed to sync: ${action.type.name}');
        }
      }
    }
    
    for (final action in actionsToRemove) {
      _pendingActions.remove(action);
    }
    
    await _savePendingActions();
    
    if (actionsToRemove.isNotEmpty) {
      _notifyConnectivityListeners();
    }
  }

  // Connectivity monitoring
  void _startConnectivityMonitoring() {
    // Simulate connectivity changes
    Future.delayed(const Duration(seconds: 10), () async {
      if (!_isOnline && await isOnline) {
        _isOnline = true;
        _showConnectivityNotification('Back online! Syncing data...');
        await _syncPendingActions();
      }
    });
  }

  // Storage simulation (in real app, use Hive/SQLite)
  Future<void> _loadCachedData() async {
    // Simulate loading from storage
    debugPrint('Loading cached data...');
  }

  Future<void> _saveCacheToStorage() async {
    // Simulate saving to storage
    debugPrint('Saving cache to storage...');
  }

  Future<void> _loadPendingActions() async {
    // Simulate loading pending actions
    debugPrint('Loading pending actions...');
  }

  Future<void> _savePendingActions() async {
    // Simulate saving pending actions
    debugPrint('Saving pending actions: ${_pendingActions.length}');
  }

  // Notification helpers
  void _showSuccessNotification(String message) {
    debugPrint('SUCCESS: $message');
  }

  void _showOfflineNotification(String message) {
    debugPrint('OFFLINE: $message');
  }

  void _showSyncNotification(String message) {
    debugPrint('SYNC: $message');
  }

  void _showErrorNotification(String message) {
    debugPrint('ERROR: $message');
  }

  void _showConnectivityNotification(String message) {
    debugPrint('CONNECTIVITY: $message');
  }

  // Connectivity listeners
  void addConnectivityListener(VoidCallback listener) {
    _connectivityListeners.add(listener);
  }

  void removeConnectivityListener(VoidCallback listener) {
    _connectivityListeners.remove(listener);
  }

  void _notifyConnectivityListeners() {
    for (final listener in _connectivityListeners) {
      listener();
    }
  }

  // Get pending actions count
  int get pendingActionsCount => _pendingActions.length;

  // Get sync status
  bool get hasPendingSync => _pendingActions.isNotEmpty;
}

// Data Models
class ProjectData {
  final String id;
  final String title;
  final String description;
  final String status;
  final double progress;
  final double budgetAllocated;
  final double budgetUtilized;
  final String state;
  final DateTime startDate;
  final DateTime endDate;
  final bool isOfflineData;

  ProjectData({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.progress,
    required this.budgetAllocated,
    required this.budgetUtilized,
    required this.state,
    required this.startDate,
    required this.endDate,
    this.isOfflineData = false,
  });

  factory ProjectData.fromJson(Map<String, dynamic> json) {
    return ProjectData(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      progress: json['progress'].toDouble(),
      budgetAllocated: json['budget_allocated'].toDouble(),
      budgetUtilized: json['budget_utilized'].toDouble(),
      state: json['state'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      isOfflineData: json['is_offline_data'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'progress': progress,
      'budget_allocated': budgetAllocated,
      'budget_utilized': budgetUtilized,
      'state': state,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'is_offline_data': isOfflineData,
    };
  }
}

class OfflineAction {
  final String id;
  final ActionType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  int retryCount;

  OfflineAction({
    required this.id,
    required this.type,
    required this.data,
    required this.timestamp,
    this.retryCount = 0,
  });
}

enum ActionType {
  submitEvidence,
  submitFundRequest,
  updateProjectStatus,
  uploadDocument,
  submitReport,
}

// Offline Status Widget
class OfflineStatusIndicator extends StatefulWidget {
  const OfflineStatusIndicator({super.key});

  @override
  State<OfflineStatusIndicator> createState() => _OfflineStatusIndicatorState();
}

class _OfflineStatusIndicatorState extends State<OfflineStatusIndicator> {
  final OfflineFirstService _offlineService = OfflineFirstService();
  bool _isOnline = true;
  int _pendingActions = 0;

  @override
  void initState() {
    super.initState();
    _checkStatus();
    _offlineService.addConnectivityListener(_onConnectivityChanged);
  }

  @override
  void dispose() {
    _offlineService.removeConnectivityListener(_onConnectivityChanged);
    super.dispose();
  }

  void _checkStatus() async {
    final isOnline = await _offlineService.isOnline;
    final pendingActions = _offlineService.pendingActionsCount;
    
    setState(() {
      _isOnline = isOnline;
      _pendingActions = pendingActions;
    });
  }

  void _onConnectivityChanged() {
    _checkStatus();
  }

  @override
  Widget build(BuildContext context) {
    if (_isOnline && _pendingActions == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _isOnline ? Colors.orange[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isOnline ? Colors.orange : Colors.red,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isOnline ? Icons.sync : Icons.wifi_off,
            size: 16,
            color: _isOnline ? Colors.orange[700] : Colors.red[700],
          ),
          const SizedBox(width: 4),
          Text(
            _isOnline 
                ? 'Syncing $_pendingActions items'
                : 'Offline mode',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _isOnline ? Colors.orange[700] : Colors.red[700],
            ),
          ),
        ],
      ),
    );
  }
}
