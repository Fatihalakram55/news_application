import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/article.dart';

class NewsService {

  static const String _baseUrl = 'newsapi.org';
  static const String _topHeadlinesPath = '/v2/top-headlines';
  static const String _everythingPath = '/v2/everything';
  static const String _defaultCountry = 'us';
  static const int _pageSize = 20;
  static const String _defaultSortBy = 'publishedAt';

  Future<List<Article>> fetchTopHeadlines({
    String category = 'general',
  }) async {
    final uri = Uri.https(
      _baseUrl,
      _topHeadlinesPath,
      {
        'country': _defaultCountry,
        'category': category,
        'pageSize': _pageSize.toString(),
      },
    );

    return _getArticles(uri);
  }

  Future<List<Article>> searchArticles({
    required String query,
  }) async {
    final uri = Uri.https(
      _baseUrl,
      _everythingPath,
      {
        'q': query,
        'pageSize': _pageSize.toString(),
        'sortBy': _defaultSortBy,
      },
    );

    return _getArticles(uri);
  }

  Future<List<Article>> _getArticles(Uri uri) async {

    final String apiKey = dotenv.env['NEWS_API_KEY'] ?? '';

    if (apiKey.isEmpty) {
      throw Exception(
        'NEWS_API_KEY belum diatur. Periksa file .env.',
      );
    }

    final response = await http.get(
      uri,
      headers: {
        'X-Api-Key': apiKey,
      },
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200 || data['status'] != 'ok') {
      throw Exception(
        data['message'] ?? 'Gagal mengambil berita (HTTP ${response.statusCode})',
      );
    }

    final List<dynamic> articlesJson =
        data['articles'] as List<dynamic>? ?? [];

    return articlesJson
        .map((json) => Article.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}