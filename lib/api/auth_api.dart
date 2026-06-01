// lib/api/auth_api.dart

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthApi {
  // Inicializamos el objeto de Google SignIn solicitando email y perfil básico
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_URL'] ?? 'http://localhost:8000/api',
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  /// Abre el modal nativo de Google y retorna el usuario autenticado
  static Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      // Inicia el flujo de autenticación
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      return account;
    } catch (error) {
      // En producción, aquí podrías usar un logger o enviar el error a un servicio como Crashlytics
      print("Error en Google Sign-In: $error");
      return null;
    }
  }

  /// Inicia sesión con correo y contraseña
  static Future<Map<String, dynamic>?> loginWithEmail(
    String correo,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'correo': correo, 'password': password},
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        final userData = response.data['data'];
        List<dynamic> roles = userData['user']['roles'];
        for(var rol in roles)
        {
          if(rol['id'] == 2){
            int userId = userData['user']['id'];
            await suscribirVendedor(userId);
          }
          if(rol['id'] == 3){
            int userId = userData['user']['id'];
            await suscibirirCliente(userId);
          }
        }
        return response.data['data'];
      }
    } catch (error) {
      print("Error en login con email: $error");
    }
    return null;
  }

  /// Registra un nuevo usuario
  static Future<Map<String, dynamic>?> register({
    required String nombre,
    required String correo,
    required String password,
    required String passwordConfirmation,
    required String telefono,
    required String carrera,
    required List<int> idRol,
  }) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {
          'nombre': nombre,
          'correo': correo,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'telefono': telefono,
          'carrera': carrera,
          'id_rol': idRol,
        },
      );
      if (response.statusCode == 201 && response.data['success'] == true) {
        return response.data['data'];
      }
    } catch (error) {
      print("Error en registro: $error");
    }
    return null;
  }

  /// Cierra la sesión actual
  static Future<void> signOut(int userId) async {
    try {
      // Desuscribir del tema antes de limpiar todo
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
    } catch (error) {
      print("Error al cerrar sesión: $error");
    }
  }
  /// Suscribe al usuario a su tema privado de vendedor
  static Future<void> suscribirVendedor(int userId) async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic("vendedor_$userId");
      print("🔔 Suscrito exitosamente al tema: vendedor_$userId");
    } catch (e) {
      print("❌ Error al suscribir al tema: $e");
    }
  }

  static Future<void> desuscribirVendedor(int userId) async {
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic("vendedor_$userId");
      print("🔕 Desuscrito del tema: vendedor_$userId");
    } catch (e) {
      print("❌ Error al desuscribir del tema: $e");
    }
  }



  static Future<void> suscibirirCliente(int userId) async
  {
    try {
      await FirebaseMessaging.instance.subscribeToTopic("cliente_$userId");
      print("🔔 Suscrito exitosamente al tema: cliente_$userId");
    } catch (e)
    {
      print("❌ Error al suscribir al tema: $e");
    }
  }
  static Future<void> desuscribirCliente(int userId) async
  {
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic("cliente_$userId");
      print("🔕 Desuscrito del tema: cliente_$userId");
    } catch (e)
    {
      print("❌ Error al desuscribir del tema: $e");
    }
  }

}
