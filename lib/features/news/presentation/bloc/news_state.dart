import 'package:equatable/equatable.dart';

import '../../data/models/article.dart';

enum NewsStatus { initial, loading, success, failure }

class NewsState extends Equatable {
  final NewsStatus status;
  final List<Article> articles;
  final String category;
  final int page;
  final int totalResults;
  final bool isLoadingMore;
  final String? error;

  const NewsState({
    this.status = NewsStatus.initial,
    this.articles = const [],
    this.category = 'All',
    this.page = 0,
    this.totalResults = 0,
    this.isLoadingMore = false,
    this.error,
  });

  bool get hasMore => articles.length < totalResults;

  NewsState copyWith({
    NewsStatus? status,
    List<Article>? articles,
    String? category,
    int? page,
    int? totalResults,
    bool? isLoadingMore,
    String? error,
  }) {
    return NewsState(
      status: status ?? this.status,
      articles: articles ?? this.articles,
      category: category ?? this.category,
      page: page ?? this.page,
      totalResults: totalResults ?? this.totalResults,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    articles,
    category,
    page,
    totalResults,
    isLoadingMore,
    error,
  ];
}
