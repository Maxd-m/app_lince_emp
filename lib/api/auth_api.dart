// lib/api/auth_api.dart

import 'package:google_sign_in/google_sign_in.dart';

class AuthApi {
  // Inicializamos el objeto de Google SignIn solicitando email y perfil básico
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
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

  /// Cierra la sesión actual
  static Future<void> signOut() async {
    try {
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
    } catch (error) {
      print("Error al cerrar sesión: $error");
    }
  }
}
