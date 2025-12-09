import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blog_app/feature/blog/data/models/news_model.dart' as model;

class News {
  List<model.NewsModel> news = [];
  static const String _cachedNewsKey = 'cached_news';
  static const String _lastFetchTimeKey = 'last_fetch_time';
  static const Duration _cacheDuration = Duration(minutes: 30);
  static const Duration _timeoutDuration = Duration(seconds: 15);
  static const String _apiUrl = 'https://technews-api-n2cx.onrender.com/news';

  // Singleton pattern
  static final News _instance = News._internal();
  factory News() => _instance;
  News._internal();

  // Get cached news if valid, otherwise fetch fresh
  Future<List<model.NewsModel>> getNews({bool forceRefresh = false}) async {
    // Return cached news if still valid and not forcing refresh
    if (!forceRefresh && await _isCacheValid()) {
      await loadCachedNews();
      if (news.isNotEmpty) return news;
    }

    // Otherwise fetch fresh data
    return await _fetchFreshNews();
  }

  // Check if cached data is still valid
  Future<bool> _isCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final lastFetch = prefs.getInt(_lastFetchTimeKey) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - lastFetch) < _cacheDuration.inMilliseconds;
  }

  // Load news from cache
  Future<void> loadCachedNews() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cachedNewsKey);
      if (cached != null) {
        // Use compute to decode JSON in background
        final dynamic decoded = await compute(jsonDecode, cached);
        final List<dynamic> jsonList = decoded as List<dynamic>;
        news = jsonList.map((item) => model.NewsModel.fromJson(item)).toList();
        debugPrint('📥 Loaded ${news.length} articles from cache');
      } else {
        debugPrint('⚠️ No cached news found');
      }
    } catch (e) {
      debugPrint('❌ Error loading cached news: $e');
    }
  }

  // Save news to cache
  Future<void> _cacheNews(List<dynamic> articles) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Use compute to encode JSON in background
      final String jsonString = await compute(jsonEncode, articles);
      await prefs.setString(_cachedNewsKey, jsonString);
      await prefs.setInt(
        _lastFetchTimeKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      debugPrint('💾 Cached ${articles.length} articles');
    } catch (e) {
      debugPrint('❌ Error caching news: $e');
    }
  }

  // Fetch fresh news from API
  Future<List<model.NewsModel>> _fetchFreshNews() async {
    final client = http.Client();
    try {
      debugPrint('🌐 Fetching fresh news...');
      final response = await client
          .get(
            Uri.parse(_apiUrl),
            headers: {
              'Accept': 'application/json',
              'Cache-Control': 'no-cache',
            },
          )
          .timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        // Use compute to decode JSON in background
        final data = await compute(jsonDecode, response.body);
        final List<dynamic> articles = data['articles'] ?? [];

        if (articles.isNotEmpty) {
          news = articles
              .map((item) => model.NewsModel.fromJson(item))
              .toList();
          await _cacheNews(articles);
          debugPrint('✅ Fetched ${news.length} fresh articles');
          return news;
        }
      }

      // If we get here, something went wrong with the API
      debugPrint('⚠️ Using cached data due to API issue');
      await loadCachedNews();
      return news;
    } on TimeoutException {
      debugPrint('⏱️ Request timed out after ${_timeoutDuration.inSeconds}s');
      await loadCachedNews();
      return news;
    } catch (e) {
      debugPrint('❌ Error fetching news: $e');
      await loadCachedNews();
      return news;
    } finally {
      client.close();
    }
  }
}
