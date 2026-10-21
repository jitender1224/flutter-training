import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';

@JsonSerializable()
class Article {
  final String? author;
  final String? title;
  final String? description;

  @JsonKey(name: 'urlToImage')
  final String? imageUrl;

  final String? url;

  @JsonKey(name: 'publishedAt')
  final String? publishedAt;

  final String? content;

  @JsonKey(name: 'source', fromJson: _sourceNameFromJson)
  final String? sourceName;

  const Article({
    this.author,
    this.title,
    this.description,
    this.imageUrl,
    this.url,
    this.publishedAt,
    this.content,
    this.sourceName,
  });

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  static String? _sourceNameFromJson(dynamic source) {
    if (source is Map<String, dynamic>) {
      return source['name'] as String?;
    }
    return null;
  }
}
