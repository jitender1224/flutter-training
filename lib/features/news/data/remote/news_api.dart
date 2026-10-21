import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/news_response.dart';

part 'news_api.g.dart';

@RestApi()
abstract class NewsApi {
  factory NewsApi(Dio dio, {String? baseUrl}) = _NewsApi;

  @GET('/top-headlines')
  Future<NewsResponse> getTopHeadlines(@Queries() Map<String, dynamic> query);

  @GET('/everything')
  Future<NewsResponse> getEverything(@Queries() Map<String, dynamic> query);
}
