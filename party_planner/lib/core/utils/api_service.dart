import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:party_planner/controller/auth/login_screen_controller.dart';
import 'package:party_planner/core/utils/api_error_type.dart';
import 'package:party_planner/view/auth/login/login.dart';
import 'package:party_planner/view/home_screen.dart';

typedef FromJson<T> = T Function(Map<String, dynamic> json);

class ApiService {
  late final dio.Dio _dio;

  static String? token;
  final GetStorage _storage = GetStorage();

  ApiService({int connectTimeout = 20000, receiveTimeout = 20000}) {
    token = getToken();
    _dio = dio.Dio(
      dio.BaseOptions(
        baseUrl: 'https://magenta-quetzal-921892.hostingersite.com/api',
        connectTimeout: Duration(milliseconds: connectTimeout),
        receiveTimeout: Duration(milliseconds: receiveTimeout),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  void saveToken(String token) {
    _storage.write('auth_token', token);
    ApiService.token = token;
  }

  void clearToken() {
    _storage.remove('auth_token');
    ApiService.token = null;
    if (Get.isRegistered<LoginScreenController>()) {
      Get.delete<LoginScreenController>(force: true);
    }
    _dio.options.headers.remove('Authorization');
  }

  String? getToken() {
    return token ??
        _storage.read('auth_token') ??
        (Get.isRegistered<LoginScreenController>()
            ? Get.find<LoginScreenController>().user.token
            : null);
  }

  Future<T?> request<T>({
    required String method,
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    FromJson<T>? fromJson,
  }) async {
    try {
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }

      dio.Response response = await _dio.request(
        endpoint,
        data: data,
        options: dio.Options(method: method),
      );

      dynamic responseData = response.data["data"];
      if (fromJson != null) {
        if (responseData is List) {
          return responseData.map((e) => fromJson(e)!).whereType<T>().toList()
              as T;
        } else if (responseData is Map<String, dynamic>) {
          return fromJson(responseData) ??
              (T is Map
                  ? <String, dynamic>{} as T
                  : throw Exception('تعذر تحويل البيانات.'));
        }
      }
      return response.data;
    } on dio.DioException catch (e) {
      _handleError(e);
    }
    return null;
  }

  void _handleError(dio.DioException e) {
    ApiErrorType errorType;
    String errorMessage = 'حدث خطأ غير متوقع.';
    Map<String, dynamic>? errors;

    if (e.response != null) {
      switch (e.response?.statusCode) {
        case 400:
          errorType = ApiErrorType.validationError;
          errorMessage = e.response!.data['message'] ?? 'طلب غير صالح.';
          errors = e.response?.data['errors'];
          break;
        case 401:
          errorType = ApiErrorType.unauthorized;
          errorMessage = e.response!.data['message'] ?? 'غير مصرح لك بالوصول.';
          break;
        case 403:
          errorType = ApiErrorType.forbidden;
          errorMessage = e.response!.data['message'] ?? 'ممنوع الوصول.';
          break;
        case 404:
          errorType = ApiErrorType.notFound;
          errorMessage = e.response!.data['message'] ?? 'الطلب غير موجود.';
          break;
        case 422:
          errorType = ApiErrorType.validationError;
          errorMessage = e.response!.data['message'] ?? 'خطأ في التحقق.';
          errors = e.response?.data['errors'];
          break;
        case 500:
          errorType = ApiErrorType.serverError;
          errorMessage = e.response!.data['message'] ?? 'خطأ في السيرفر.';
          break;
        default:
          errorType = ApiErrorType.unknown;
          errorMessage = e.response!.data['message'] ?? 'حدث خطأ غير متوقع.';
      }
    } else if (e.type == dio.DioExceptionType.connectionTimeout ||
        e.type == dio.DioExceptionType.receiveTimeout) {
      errorType = ApiErrorType.timeout;
      errorMessage = 'انتهى وقت الطلب.';
    } else if (e.type == dio.DioExceptionType.connectionError) {
      errorType = ApiErrorType.noInternet;
      errorMessage = 'لا يوجد اتصال بالإنترنت.';
    } else {
      errorType = ApiErrorType.unknown;
      errorMessage = 'حدث خطأ غير متوقع.';
    }
    throw ApiError(type: errorType, message: errorMessage, errors: errors);
  }

  Future<void> autoLogin() async {
    final token = getToken();
    if (token != null) {
      try {
        final response = await get('/user');
        if (response != null) {
          Get.offAll(() => HomeScreen());
        }
      } on ApiError catch (e) {
        if (e.type == ApiErrorType.unauthorized) {
          clearToken();
          Get.offAll(() => LoginScreen());
        } else {
          Get.snackbar('خطأ', e.message, snackPosition: SnackPosition.BOTTOM);
        }
      }
    } else {
      Get.offAll(() => LoginScreen());
    }
  }

  /// تنفيذ طلب HTTP مع بيانات Multipart
  Future<T?> multipartRequest<T>({
    required String endpoint,
    required String method,
    required dio.FormData formData,
    FromJson<T>? fromJson,
  }) async {
    try {
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }
      dio.Response response = await _dio.request(
        endpoint,
        data: formData,
        options:
            dio.Options(method: method, contentType: 'multipart/form-data'),
      );
      dynamic responseData = response.data["data"];
      if (fromJson != null) {
        if (responseData is List) {
          return responseData.map((e) => fromJson(e)!).whereType<T>().toList()
              as T;
        } else if (responseData is Map<String, dynamic>) {
          return fromJson(responseData) ?? ({} as T);
        }
      }
      return response.data;
    } on dio.DioException catch (e) {
      print(e);
      _handleError(e);
    }
    return null;
  }

  Future<bool> changeUsername(String newUsername) async {
    try {
      await post('/change-username', data: {'new_username': newUsername});
      Get.snackbar('نجاح', 'تم تغيير اسم المستخدم بنجاح.',
          snackPosition: SnackPosition.BOTTOM);
      return true;
    } on ApiError catch (e) {
      if (e.type == ApiErrorType.validationError) {
        if (e.errors != null) {
          for (var error in e.errors!.values) {
            Get.snackbar('خطأ في التحقق', error.join(', '),
                snackPosition: SnackPosition.BOTTOM);
          }
        } else {
          Get.snackbar('خطأ في التحقق', e.message,
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar('خطأ', e.message, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع.',
          snackPosition: SnackPosition.BOTTOM);
    }
    return false;
  }

  Future<bool> changePassword(String currentPassword, String newPassword,
      String confirmPassword) async {
    try {
      await post('/change-password', data: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': confirmPassword,
      });
      Get.snackbar('نجاح', 'تم تغيير كلمة المرور بنجاح.',
          snackPosition: SnackPosition.BOTTOM);
      return true;
    } on ApiError catch (e) {
      if (e.type == ApiErrorType.validationError) {
        if (e.errors != null) {
          for (var error in e.errors!.values) {
            Get.snackbar('خطأ في التحقق', error.join(', '),
                snackPosition: SnackPosition.BOTTOM);
          }
        } else {
          Get.snackbar('خطأ في التحقق', e.message,
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar('خطأ', e.message, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع.',
          snackPosition: SnackPosition.BOTTOM);
    }

    return false;
  }

  /// اختصارات لطلبات HTTP
  Future<T?> get<T>(String endpoint,
      {Map<String, dynamic>? queryParameters, FromJson<T>? fromJson}) async {
    try {
      return await request(
          method: 'GET',
          endpoint: endpoint,
          queryParameters: queryParameters,
          fromJson: fromJson);
    } on ApiError catch (e) {
      if (e.type == ApiErrorType.validationError) {
        if (e.errors != null) {
          for (var error in e.errors!.values) {
            Get.snackbar('خطأ في التحقق', error.join(', '),
                snackPosition: SnackPosition.BOTTOM);
          }
        } else {
          Get.snackbar('خطأ في التحقق', e.message,
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar('خطأ', e.message, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع.',
          snackPosition: SnackPosition.BOTTOM);
      print(e);
    }
    return null;
  }

  Future<T?> post<T>(String endpoint,
      {required Map<String, dynamic> data, FromJson<T>? fromJson}) async {
    try {
      return await request(
          method: 'POST', endpoint: endpoint, data: data, fromJson: fromJson);
    } on ApiError catch (e) {
      if (e.type == ApiErrorType.validationError) {
        if (e.errors != null) {
          for (var error in e.errors!.values) {
            Get.snackbar('خطأ في التحقق', error.join(', '),
                snackPosition: SnackPosition.BOTTOM);
          }
        } else {
          Get.snackbar('خطأ في التحقق', e.message,
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar('خطأ', e.message, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع.',
          snackPosition: SnackPosition.BOTTOM);
      print(e);
    }
    return null;
  }

  Future<T?> put<T>(String endpoint,
      {required Map<String, dynamic> data, FromJson<T>? fromJson}) async {
    try {
      return await request(
          method: 'PUT', endpoint: endpoint, data: data, fromJson: fromJson);
    } on ApiError catch (e) {
      if (e.type == ApiErrorType.validationError) {
        if (e.errors != null) {
          for (var error in e.errors!.values) {
            Get.snackbar('خطأ في التحقق', error.join(', '),
                snackPosition: SnackPosition.BOTTOM);
          }
        } else {
          Get.snackbar('خطأ في التحقق', e.message,
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar('خطأ', e.message, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع.',
          snackPosition: SnackPosition.BOTTOM);
      print(e);
    }
    return null;
  }

  Future<T?> patch<T>(String endpoint,
      {Map<String, dynamic>? data, FromJson<T>? fromJson}) async {
    try {
      return await request(
          method: 'PATCH', endpoint: endpoint, data: data, fromJson: fromJson);
    } on ApiError catch (e) {
      if (e.type == ApiErrorType.validationError) {
        if (e.errors != null) {
          for (var error in e.errors!.values) {
            Get.snackbar('خطأ في التحقق', error.join(', '),
                snackPosition: SnackPosition.BOTTOM);
          }
        } else {
          Get.snackbar('خطأ في التحقق', e.message,
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar('خطأ', e.message, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع.',
          snackPosition: SnackPosition.BOTTOM);
      print(e);
    }
    return null;
  }

  Future<T?> delete<T>(String endpoint, {FromJson<T>? fromJson}) async {
    try {
      return await request(
          method: 'DELETE', endpoint: endpoint, fromJson: fromJson);
    } on ApiError catch (e) {
      if (e.type == ApiErrorType.validationError) {
        if (e.errors != null) {
          for (var error in e.errors!.values) {
            Get.snackbar('خطأ في التحقق', error.join(', '),
                snackPosition: SnackPosition.BOTTOM);
          }
        } else {
          Get.snackbar('خطأ في التحقق', e.message,
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar('خطأ', e.message, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع.',
          snackPosition: SnackPosition.BOTTOM);
      print(e);
    }
    return null;
  }
}
