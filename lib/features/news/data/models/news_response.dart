import 'package:json_annotation/json_annotation.dart';

import 'article.dart';

part 'news_response.g.dart';

@JsonSerializable(explicitToJson: true)
class NewsResponse {
  final String status;
  final int totalResults;
  final List<Article> articles;
  final String? message;

  const NewsResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
    this.message,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) =>
      _$NewsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NewsResponseToJson(this);
}
