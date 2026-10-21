import '../models/article.dart';
import '../models/news_response.dart';
import '../remote/news_api.dart';

class NewsPage {
  final List<Article> articles;
  final int totalResults;

  const NewsPage({required this.articles, required this.totalResults});
}

class NewsRepository {
  final NewsApi api;

  NewsRepository(this.api);

  Future<NewsPage> fetchNews({
    required String category,
    required int page,
  }) async {
    final Map<String, dynamic> query = {
      'country': 'in',
      'page': page,
      'pageSize': 20,
    };

    if (category == 'All') {
      query
        ..clear()
        ..addAll({
          'q':
              'India OR world OR politics OR business OR sports OR technology OR entertainment OR health OR science',
          'language': 'en',
          'sortBy': 'publishedAt',
          'page': page,
          'pageSize': 20,
        });
    } else if (category == 'Politics') {
      query
        ..clear()
        ..addAll({
          'q': 'politics',
          'language': 'en',
          'sortBy': 'publishedAt',
          'page': page,
          'pageSize': 20,
        });
    } else if (category != 'All') {
      const categories = {
        'Business': 'business',
        'Sports': 'sports',
        'Technology': 'technology',
        'Entertainment': 'entertainment',
        'Health': 'health',
        'Science': 'science',
      };

      query['category'] = categories[category] ?? 'general';
    }

    NewsResponse response;

    if (category == 'All' || category == 'Politics') {
      response = await api.getEverything(query);
    } else {
      response = await api.getTopHeadlines(query);

      if ((response.totalResults == 0 || response.articles.isEmpty) &&
          category != 'All') {
        final fallbackQuery = {
          'q': category.toLowerCase(),
          'language': 'en',
          'sortBy': 'publishedAt',
          'page': page,
          'pageSize': 20,
        };

        response = await api.getEverything(fallbackQuery);
      }
    }

    if (response.status != 'ok') {
      throw Exception(response.message ?? 'Unable to load news');
    }

    final articles =
        response.articles.where((article) {
          final title = article.title;
          return title != null &&
              title.trim().isNotEmpty &&
              title != '[Removed]';
        }).toList();

    return NewsPage(articles: articles, totalResults: response.totalResults);
  }
}
