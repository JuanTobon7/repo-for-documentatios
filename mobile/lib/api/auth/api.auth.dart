import 'package:mobile/api/conf/api.dart';

class ApiAuth {
  final ApiClient apiClient;
  ApiAuth(this.apiClient);

  static const String baseModuleUrl = '/auth';

  Future<dynamic> register(Map<String, dynamic> userData) async {
    try {
        final response = await apiClient.dio.post('$baseModuleUrl/register', data: userData);
        print('statusCode ${response.statusCode}');
        if (response.statusCode != 200 && response.statusCode != 201) {
          throw Exception('Failed to register user: ${response.statusCode}');
        }
        return response.data;
      } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> login(Map<String, dynamic> userData) async {
    try {
      final response = await apiClient.dio.post('$baseModuleUrl/login', data: userData);
        print(response);
        if (response.statusCode != 200 && response.statusCode != 201) {
          throw Exception('Failed to register user: ${response.statusCode}');
        }
        final String token = response.data['data']['accessToken'];
        ApiClient.accessToken = token;
        return response.data;
      } catch (e) {
      rethrow;
    }
  }
  
}
