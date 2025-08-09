import 'package:dio/dio.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/common/AlertError.dart';

class ApiClient {
  // instancia singleton privada
  static final ApiClient _instance = ApiClient._internal();
  static String accessToken = '';
  // factory pública que devuelve la misma instancia siempre
  factory ApiClient() => _instance;

  late final Dio dio;

  // constructor privado
  ApiClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: dotenv.env['API_URL'] ?? 'http://127.0.0.1:3000/api/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    // opcional: interceptores, logging, etc
    dio.interceptors.add(LogInterceptor(responseBody: true));

    dio.interceptors.add(
        InterceptorsWrapper(
            onRequest: (options,handler){
              if(accessToken.isNotEmpty){
                options.headers['Authorization'] = 'Bearer $accessToken';
              }
              return handler.next(options);
            }
        )
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException err, ErrorInterceptorHandler handler) {
          // Aquí manejas el error globalmente
          if (err.type == DioExceptionType.connectionTimeout) {
            AlertHelper.show('⏳ Connection timeout','El servidor se ha demorado en responder, intentalo más tarde');
          } else if (err.type == DioExceptionType.badCertificate) {
            AlertHelper.show('Credenciales Invalidas', err.response?.data['message']??'Vuelve a Iniciar Sesion');
            navigatorKey.currentState?.pushReplacementNamed('/login');
          }else if (err.type == DioExceptionType.badResponse) {
            AlertHelper.show('Ups algo salio mal', err.response?.data['message']??'Hazlo nuevamente');
          } else if (err.type == DioExceptionType.connectionError) {
            AlertHelper.show('📡 Network error', 'Revisa tu conexion de internet');
          }else if(err.response?.statusCode == 404){
            AlertHelper.show('Recurso no Encontrado', err.response?.data['message']??'No se encontro el recurso que buscas');
          }
          else {
            AlertHelper.show('⚠️ Unknown Request error', 'Contacta a los desarrolladores e informa el problema: ${err.message}');
          }
          handler.next(err);
        },
      ),
    );

  }
}