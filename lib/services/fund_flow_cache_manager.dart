import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fund_flow/fund_flow_models.dart';

// Fund Flow Cache Management System
class FundFlowCacheManager {
  static const String _cacheKeyPrefix = 'fund_flow_data';
  static const Duration _defaultCacheDuration = Duration(minutes: 5);
  static const Duration _realTimeCacheDuration = Duration(seconds: 30);
  static const int _maxCacheEntries = 50;

  static final Map<String, FundFlowCacheEntry> _memoryCache = {};

  // Get cached fund flow data
  static Future<FundFlowData?> getCachedData(
    String level,
    String userRole, {
    String? filterState,
    String? timeRange,
  }) async {
    final cacheKey = _generateCacheKey(level, userRole, filterState, timeRange);
    
    // Check memory cache first
    final memoryCacheEntry = _memoryCache[cacheKey];
    if (memoryCacheEntry != null && !memoryCacheEntry.isExpired) {
      return memoryCacheEntry.data;
    }

    // Check persistent cache
    final prefs = await SharedPreferences.getInstance();
    final cachedJson = prefs.getString(cacheKey);
    final cacheTime = prefs.getInt('${cacheKey}_time');
    
    if (cachedJson != null && cacheTime != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final cacheDuration = _getCacheDuration(level, userRole);
      
      if (now - cacheTime < cacheDuration.inMilliseconds) {
        try {
          final data = FundFlowData.fromJson(jsonDecode(cachedJson));
          
          // Update memory cache
          _memoryCache[cacheKey] = FundFlowCacheEntry(
            key: cacheKey,
            data: data,
            cachedAt: DateTime.fromMillisecondsSinceEpoch(cacheTime),
            ttl: cacheDuration,
          );
          
          return data;
        } catch (e) {
          // Remove corrupted cache entry
          await _removeCacheEntry(cacheKey);
        }
      }
    }
    
    return null;
  }

  // Cache fund flow data
  static Future<void> cacheData(
    String level,
    String userRole,
    FundFlowData data, {
    String? filterState,
    String? timeRange,
  }) async {
    final cacheKey = _generateCacheKey(level, userRole, filterState, timeRange);
    final now = DateTime.now();
    final cacheDuration = _getCacheDuration(level, userRole);
    
    // Update memory cache
    _memoryCache[cacheKey] = FundFlowCacheEntry(
      key: cacheKey,
      data: data,
      cachedAt: now,
      ttl: cacheDuration,
    );
    
    // Maintain memory cache size
    _cleanupMemoryCache();
    
    // Update persistent cache
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(cacheKey, jsonEncode(data.toJson()));
      await prefs.setInt('${cacheKey}_time', now.millisecondsSinceEpoch);
      
      // Track cache statistics
      await _updateCacheStatistics(cacheKey, data);
    } catch (e) {
      // Handle cache write errors gracefully
      print('Cache write error: $e');
    }
  }

  // Invalidate specific cache entry
  static Future<void> invalidateCache(
    String level,
    String userRole, {
    String? filterState,
    String? timeRange,
  }) async {
    final cacheKey = _generateCacheKey(level, userRole, filterState, timeRange);
    await _removeCacheEntry(cacheKey);
  }

  // Invalidate all cache entries for a user role
  static Future<void> invalidateUserCache(String userRole) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    
    for (final key in keys) {
      if (key.startsWith(_cacheKeyPrefix) && key.contains(userRole)) {
        await prefs.remove(key);
        await prefs.remove('${key}_time');
        _memoryCache.remove(key);
      }
    }
  }

  // Clear all cache
  static Future<void> clearAllCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    
    for (final key in keys) {
      if (key.startsWith(_cacheKeyPrefix)) {
        await prefs.remove(key);
        await prefs.remove('${key}_time');
      }
    }
    
    _memoryCache.clear();
  }

  // Get cache statistics
  static Future<CacheStatistics> getCacheStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    
    int totalEntries = 0;
    int expiredEntries = 0;
    double totalSizeKB = 0;
    
    for (final key in keys) {
      if (key.startsWith(_cacheKeyPrefix) && !key.endsWith('_time')) {
        totalEntries++;
        
        final cachedJson = prefs.getString(key);
        if (cachedJson != null) {
          totalSizeKB += cachedJson.length / 1024;
          
          final cacheTime = prefs.getInt('${key}_time');
          if (cacheTime != null) {
            final age = DateTime.now().millisecondsSinceEpoch - cacheTime;
            if (age > _defaultCacheDuration.inMilliseconds) {
              expiredEntries++;
            }
          }
        }
      }
    }
    
    return CacheStatistics(
      totalEntries: totalEntries,
      expiredEntries: expiredEntries,
      memoryEntries: _memoryCache.length,
      totalSizeKB: totalSizeKB,
      hitRate: await _getCacheHitRate(),
    );
  }

  // Preload cache for common scenarios
  static Future<void> preloadCache(String userRole) async {
    final commonScenarios = _getCommonCacheScenarios(userRole);
    
    for (final scenario in commonScenarios) {
      // Check if already cached
      final cached = await getCachedData(
        scenario['level'],
        userRole,
        filterState: scenario['filterState'],
        timeRange: scenario['timeRange'],
      );
      
      if (cached == null) {
        // Trigger background load (would integrate with actual data service)
        _scheduleBackgroundLoad(scenario, userRole);
      }
    }
  }

  // Private helper methods
  static String _generateCacheKey(
    String level,
    String userRole,
    String? filterState,
    String? timeRange,
  ) {
    final parts = [
      _cacheKeyPrefix,
      level,
      userRole,
      filterState ?? 'all',
      timeRange ?? 'default',
    ];
    return parts.join('_');
  }

  static Duration _getCacheDuration(String level, String userRole) {
    // Real-time data for centre admins
    if (userRole == 'centre_admin' && level == 'national') {
      return _realTimeCacheDuration;
    }
    
    // Longer cache for project-level data
    if (level == 'project') {
      return const Duration(minutes: 15);
    }
    
    return _defaultCacheDuration;
  }

  static void _cleanupMemoryCache() {
    if (_memoryCache.length > _maxCacheEntries) {
      // Remove oldest entries
      final sortedEntries = _memoryCache.entries.toList()
        ..sort((a, b) => a.value.cachedAt.compareTo(b.value.cachedAt));
      
      final entriesToRemove = sortedEntries.take(_memoryCache.length - _maxCacheEntries);
      for (final entry in entriesToRemove) {
        _memoryCache.remove(entry.key);
      }
    }
    
    // Remove expired entries
    _memoryCache.removeWhere((key, entry) => entry.isExpired);
  }

  static Future<void> _removeCacheEntry(String cacheKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(cacheKey);
    await prefs.remove('${cacheKey}_time');
    _memoryCache.remove(cacheKey);
  }

  static Future<void> _updateCacheStatistics(String cacheKey, FundFlowData data) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Update cache hit statistics
    final hits = prefs.getInt('cache_hits') ?? 0;
    await prefs.setInt('cache_hits', hits);
    
    // Track data freshness
    await prefs.setInt('${cacheKey}_nodes', data.nodes.length);
    await prefs.setInt('${cacheKey}_links', data.links.length);
  }

  static Future<double> _getCacheHitRate() async {
    final prefs = await SharedPreferences.getInstance();
    final hits = prefs.getInt('cache_hits') ?? 0;
    final misses = prefs.getInt('cache_misses') ?? 0;
    
    if (hits + misses == 0) return 0.0;
    return hits / (hits + misses);
  }

  static List<Map<String, String?>> _getCommonCacheScenarios(String userRole) {
    switch (userRole) {
      case 'centre_admin':
        return [
          {'level': 'national', 'filterState': null, 'timeRange': '1_year'},
          {'level': 'state', 'filterState': null, 'timeRange': '6_months'},
        ];
      case 'state_officer':
        return [
          {'level': 'state', 'filterState': 'current', 'timeRange': '1_year'},
          {'level': 'district', 'filterState': 'current', 'timeRange': '6_months'},
        ];
      default:
        return [
          {'level': 'project', 'filterState': null, 'timeRange': '3_months'},
        ];
    }
  }

  static void _scheduleBackgroundLoad(Map<String, String?> scenario, String userRole) {
    // In a real implementation, this would trigger a background data fetch
    // For now, we'll just log the intent
    print('Scheduling background load for: $scenario');
  }
}

// Cache Statistics Model
class CacheStatistics {
  final int totalEntries;
  final int expiredEntries;
  final int memoryEntries;
  final double totalSizeKB;
  final double hitRate;

  CacheStatistics({
    required this.totalEntries,
    required this.expiredEntries,
    required this.memoryEntries,
    required this.totalSizeKB,
    required this.hitRate,
  });

  double get efficiency => totalEntries > 0 ? (totalEntries - expiredEntries) / totalEntries : 0.0;
  
  Map<String, dynamic> toJson() {
    return {
      'total_entries': totalEntries,
      'expired_entries': expiredEntries,
      'memory_entries': memoryEntries,
      'total_size_kb': totalSizeKB,
      'hit_rate': hitRate,
      'efficiency': efficiency,
    };
  }
}
