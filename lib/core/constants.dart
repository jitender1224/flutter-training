class AppConstants {
  static const String baseUrl = 'https://newsapi.org/v2';

  // Replace with your NewsAPI key.
  static const String apiKey = String.fromEnvironment('NEWS_API_KEY');

  static const int pageSize = 20;
}
