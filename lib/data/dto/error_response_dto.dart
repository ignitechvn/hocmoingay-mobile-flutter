class ErrorResponseDto {
  final int statusCode;
  final String message;
  final String error;
  final List<String>? details;

  const ErrorResponseDto({
    required this.statusCode,
    required this.message,
    required this.error,
    this.details,
  });

  factory ErrorResponseDto.fromJson(Map<String, dynamic> json) {
    return ErrorResponseDto(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      error: json['error'] as String,
      details:
          json['details'] != null ? List<String>.from(json['details']) : null,
    );
  }

  @override
  String toString() {
    return 'ErrorResponseDto(statusCode: $statusCode, message: $message, error: $error, details: $details)';
  }
}
