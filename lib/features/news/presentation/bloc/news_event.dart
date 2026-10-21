import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class LoadNews extends NewsEvent {
  final String category;

  const LoadNews(this.category);

  @override
  List<Object?> get props => [category];
}

class LoadMoreNews extends NewsEvent {
  const LoadMoreNews();
}
