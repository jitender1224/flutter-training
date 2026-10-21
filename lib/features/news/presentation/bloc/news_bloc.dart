import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/news_repository.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository repository;

  NewsBloc(this.repository) : super(const NewsState()) {
    on<LoadNews>(_onLoadNews);
    on<LoadMoreNews>(_onLoadMore);
  }

  Future<void> _onLoadNews(LoadNews event, Emitter<NewsState> emit) async {
    emit(NewsState(status: NewsStatus.loading, category: event.category));

    try {
      final result = await repository.fetchNews(
        category: event.category,
        page: 1,
      );

      emit(
        NewsState(
          status: NewsStatus.success,
          category: event.category,
          articles: result.articles,
          page: 1,
          totalResults: result.totalResults,
        ),
      );
    } catch (e) {
      emit(
        NewsState(
          status: NewsStatus.failure,
          category: event.category,
          error: _message(e),
        ),
      );
    }
  }

  Future<void> _onLoadMore(LoadMoreNews event, Emitter<NewsState> emit) async {
    if (state.status != NewsStatus.success ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }

    final current = state;

    emit(current.copyWith(isLoadingMore: true));

    try {
      final result = await repository.fetchNews(
        category: current.category,
        page: current.page + 1,
      );

      emit(
        current.copyWith(
          articles: [...current.articles, ...result.articles],
          page: current.page + 1,
          totalResults: result.totalResults,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(current.copyWith(isLoadingMore: false, error: _message(e)));
    }
  }

  String _message(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
