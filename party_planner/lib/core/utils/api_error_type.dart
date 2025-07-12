enum ApiErrorType {
  validationError,
  unauthorized,
  forbidden,
  notFound,
  serverError,
  timeout,
  noInternet,
  unknown,
}

class ApiError implements Exception {
  final ApiErrorType type;
  final String message;
  final Map<String, dynamic>? errors;

  ApiError({required this.type, required this.message, this.errors});
}
