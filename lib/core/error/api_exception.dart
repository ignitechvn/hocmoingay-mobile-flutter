class ApiException implements Exception {
  final String message;
  final String errorCode;
  final int statusCode;
  final List<String>? details;

  const ApiException({
    required this.message,
    required this.errorCode,
    required this.statusCode,
    this.details,
  });

  @override
  String toString() => message;
}
