import 'package:dio/dio.dart';

class HttpClient {
  final Dio _dio;

  HttpClient([Dio? dio]) : _dio = dio ?? Dio();

  Future<Response<dynamic>> get(String path) {
    return _dio.get<dynamic>(path);
  }
}