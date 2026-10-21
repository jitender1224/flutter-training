// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) => Article(
  author: json['author'] as String?,
  title: json['title'] as String?,
  description: json['description'] as String?,
  imageUrl: json['urlToImage'] as String?,
  url: json['url'] as String?,
  publishedAt: json['publishedAt'] as String?,
  content: json['content'] as String?,
  sourceName: Article._sourceNameFromJson(json['source']),
);

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
  'author': instance.author,
  'title': instance.title,
  'description': instance.description,
  'urlToImage': instance.imageUrl,
  'url': instance.url,
  'publishedAt': instance.publishedAt,
  'content': instance.content,
  'source': instance.sourceName,
};
