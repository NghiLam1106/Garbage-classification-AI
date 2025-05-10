import 'package:dio/dio.dart';
import '../constants/endpoints.dart'; 

class DioClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: Endpoints.apiUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  static Dio get dio => _dio;
}
