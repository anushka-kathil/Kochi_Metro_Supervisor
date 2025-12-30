import 'package:dio/dio.dart';

import 'package:get/get.dart' hide Response;

import '../../core/constants/app_constants.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(_ApiInterceptor());
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return Exception('Connection timeout');

        case DioExceptionType.connectionError:
          return Exception(AppConstants.networkErrorMessage);

        case DioExceptionType.badResponse:
          return Exception(error.response?.data['message'] ?? 'Server error');

        default:
          return Exception(AppConstants.genericErrorMessage);
      }
    }

    return Exception(AppConstants.genericErrorMessage);
  }
}

class _ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token if available

    // final token = Get.find<StorageService>().readString(AppConstants.authTokenKey);

    // if (token != null) {

    //   options.headers['Authorization'] = 'Bearer $token';

    // }

    super.onRequest(options, handler);
  }
}
