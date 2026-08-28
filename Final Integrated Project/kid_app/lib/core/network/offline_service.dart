import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineService {
  OfflineService._();
  static final OfflineService instance = OfflineService._();

  static const String _syncQueueKey = 'sync_queue';
  static const String _cachedSubjectsKey = 'cached_subjects';

  Future<void> cacheContent(String key, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cache_$key', jsonEncode(data));
  }

  Future<Map<String, dynamic>?> getCachedContent(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('cache_$key');
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> clearCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cache_$key');
  }

  Future<void> clearAllCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith('cache_'));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  Future<void> addToSyncQueue(Map<String, dynamic> item) async {
    final queue = await getSyncQueue();
    queue.add(item);
    await _writeSyncQueue(queue);
  }

  Future<List<Map<String, dynamic>>> getSyncQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_syncQueueKey);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> clearSyncQueue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_syncQueueKey);
  }

  Future<void> removeFromSyncQueue(int index) async {
    final queue = await getSyncQueue();
    if (index < 0 || index >= queue.length) return;
    queue.removeAt(index);
    await _writeSyncQueue(queue);
  }

  Future<void> _writeSyncQueue(List<Map<String, dynamic>> queue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_syncQueueKey, jsonEncode(queue));
  }

  Future<void> saveOfflineProgress(
      String childId, Map<String, dynamic> progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'offline_progress_$childId', jsonEncode(progress));
  }

  Future<Map<String, dynamic>?> getOfflineProgress(String childId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('offline_progress_$childId');
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> cacheSubjects(
      List<Map<String, dynamic>> subjects) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cachedSubjectsKey, jsonEncode(subjects));
  }

  Future<List<Map<String, dynamic>>?> getCachedSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cachedSubjectsKey);
    if (raw == null) return null;
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> cacheLessons(
      String subjectId, List<Map<String, dynamic>> lessons) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'cached_lessons_$subjectId', jsonEncode(lessons));
  }

  Future<List<Map<String, dynamic>>?> getCachedLessons(
      String subjectId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('cached_lessons_$subjectId');
    if (raw == null) return null;
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }
}
