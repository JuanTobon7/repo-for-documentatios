class ApiResponse<T> {
  final bool success;
  final String message;
  final String timestamp;
  final String path;
  final T data;

  ApiResponse({
    required this.success,
    required this.message,
    required this.timestamp,
    required this.path,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse(
      success: json['success'],
      message: json['message'],
      timestamp: json['timestamp'],
      path: json['path'],
      data: fromJsonT(json['data']),
    );
  }

  Map<String, dynamic> toJson(Object Function(T) toJsonT) {
    return {
      'success': success,
      'message': message,
      'timestamp': timestamp,
      'path': path,
      'data': toJsonT(data),
    };
  }
}
