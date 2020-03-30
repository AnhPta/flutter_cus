import 'package:dio/dio.dart';

BaseOptions options = BaseOptions(
  baseUrl: "https://dev-gateway.goship.asia",
  connectTimeout: 10000,
  receiveTimeout: 10000,
);

Dio httpClient = new Dio(options);
