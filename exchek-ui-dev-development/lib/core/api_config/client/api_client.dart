// ignore_for_file: constant_identifier_names
import 'package:exchek/core/utils/exports.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:http_parser/http_parser.dart';

class ApiClient {
  final Dio _dio;
  ApiClient()
    : _dio =
          Dio()
            ..interceptors.add(
              PrettyDioLogger(
                requestHeader: true,
                requestBody: true,
                responseHeader: true,
                responseBody: true,
                request: true,
                error: true,
                compact: true,
                maxWidth: 90,
              ),
            ) {
    buildHeaders();
  }
  Future<void> buildHeaders() async {
    final headers = await _buildHeaders();
    _dio.options.headers = headers;
  }

  // --------------------------- HEADERS ---------------------------

  static Future<Map<String, String>> _buildHeaders() async {
    final header = <String, String>{};
    String? deviceToken = await Prefobj.preferences.get(Prefkeys.authToken);
    if (deviceToken != null && deviceToken.isNotEmpty) {
      header['Authorization'] = 'Bearer $deviceToken';
    }
    return header;
  }

  // --------------------------- REQUEST METHOD ---------------------------

  Future<Map<String, dynamic>> request(
    RequestType type,
    String path, {
    dynamic data,
    Map<String, dynamic>? multipartData,
    bool isShowToast = true,
  }) async {
    try {
      Logger.info("isSchedulerRunning>>>> ${TokenManager.isSchedulerRunning}");
      final String? token = await Prefobj.preferences.get(Prefkeys.authToken);
      if(!TokenManager.isSchedulerRunning && !path.contains('auth/logout') && token != null ){
        TokenManager.startScheduler();
      }
       Prefobj.preferences.put(Prefkeys.currentPath, path);
      if( !path.contains('auth/refresh-token')){
         await TokenManager.waitIfRefreshing();
      }
      await buildHeaders();
      final Response response = switch (type) {
        RequestType.GET => await _dio.get(path),
        RequestType.POST => await _dio.post(path, data: data),
        RequestType.PUT => await _dio.put(path, data: data),
        RequestType.DELETE => await _dio.delete(path),
        RequestType.PATCH => await _dio.patch(path, data: data),
        RequestType.MULTIPART_POST => await _dio.post(path, data: await _buildMultipartForm(multipartData)),
        RequestType.MULTIPART_PUT => await _dio.put(path, data: await _buildMultipartForm(multipartData)),
      };

      return _handleSuccess(response);
    } on DioException catch (error) {
      return isShowToast ? _handleDioError(error) : error.response?.data;
    } catch (e) {
      rethrow;
    }
  }

  // --------------------------- SUCCESS HANDLERS ---------------------------

  Map<String, dynamic> _handleSuccess(Response response) {
     
    if ([200, 201, 204].contains(response.statusCode)) {
      return response.data;
    } else {
      throw _handleFailure(response);
    }
  }

  // --------------------------- ERROR HANDLERS ---------------------------

 Future<DioException> _handleFailure(Response response) async {
  final code = response.statusCode ?? 0;
  final responseData = response.data;
  String message = "Something went wrong";

  if (responseData is Map<String, dynamic>) {
    if (responseData.containsKey('error')) {
      message = responseData['error'];
    }
  }
  // Toast messages based on status code
  if ([400, 403, 422, 500].contains(code)) {
    AppToast.show(message: message, type: ToastificationType.error);
  } else if ([404, 409].contains(code)) {
    AppToast.show(message: message, type: ToastificationType.warning);
  } else if ([429, 503].contains(code)) {
    AppToast.show(message: message, type: ToastificationType.info);
  } else if (code == 401) {
    _handleSessionExpired();
    final String path =
        (await Prefobj.preferences.get(Prefkeys.currentPath))?.toString() ?? "";

    if (!path.contains('auth/refresh-token')) {
      AppToast.show(
        message: "For security reasons, please log in again.",
        type: ToastificationType.info,
      );
    }
  } else {
    AppToast.show(message: message, type: ToastificationType.error);
  }

  return DioException(
    requestOptions: response.requestOptions,
    response: response,
    type: DioExceptionType.badResponse,
  );
}

  void _handleSessionExpired() async {
     TokenManager.stopScheduler();
      await Prefobj.preferences.deleteAll();
    final context = rootNavigatorKey.currentContext;
    if (context != null) {
      GoRouter.of(context).go(RouteUri.logoutRoute);
    }
  }

  Map<String, dynamic> _handleDioError(DioException error) {
    if (error.response != null) {
      throw _handleFailure(error.response!);
    } else {
      final message = error.message ?? "Network error. Please check your connection.";
      AppToast.show(message: message, type: ToastificationType.error);
      throw DioException(requestOptions: error.requestOptions, error: error.error, type: DioExceptionType.unknown);
    }
  }

  // --------------------------- MULTIPART FORM BUILDER ---------------------------
  Future<FormData> _buildMultipartForm(Map<String, dynamic>? data) async {
    final formData = FormData();

    if (data == null || data.isEmpty) return formData;

    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value == null) continue;

      if (value is FileData) {
        // Determine MIME type based on file extension
        String extension = value.name.split('.').last.toLowerCase();
        String? mimeType;

        switch (extension) {
          case 'pdf':
            mimeType = 'application/pdf';
            break;
          case 'jpeg':
            mimeType = 'image/jpeg';
            break;
          case 'png':
            mimeType = 'image/png';
            break;
        }

        formData.files.add(
          MapEntry(
            key,
            MultipartFile.fromBytes(
              value.bytes,
              filename: value.name,
              contentType: mimeType != null ? MediaType.parse(mimeType) : null,
            ),
          ),
        );
      } else {
        formData.fields.add(MapEntry(key, value.toString()));
      }
    }

    return formData;
  }
}
