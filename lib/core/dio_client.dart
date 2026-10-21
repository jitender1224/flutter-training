import 'package:dio/dio.dart';

import 'constants.dart';
import '../features/news/data/remote/news_api.dart';

NewsApi createNewsApi() {
  final apiKey = AppConstants.apiKey.trim();

  if (apiKey.isEmpty) {
    throw Exception(
      'NewsAPI key is missing. Run with --dart-define=NEWS_API_KEY=YOUR_KEY',
    );
  }

  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {'X-Api-Key': apiKey},
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  return NewsApi(dio);
}
