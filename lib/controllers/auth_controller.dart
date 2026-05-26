// lib/controllers/auth_controller.dart

import 'package:app_lince_emp/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../api/auth_api.dart';

class AuthController extends GetxController {
  // Variable reactiva para almacenar el usuario de Google
  // Usamos Rxn para indicar que puede ser nulo
  final Rxn<GoogleSignInAccount> currentUser = Rxn<GoogleSignInAccount>();

  // Variables reactivas para el login con email y persistencia de estado
  final RxnString token = RxnString();
  final RxMap<String, dynamic> userData = <String, dynamic>{}.obs;
  final RxList<dynamic> roles = <dynamic>[].obs;
  final RxnInt userId = RxnInt();

  // Variable reactiva para el estado de carga
  final RxBool isLoading = false.obs;

  /// Método para iniciar sesión
  Future<void> login() async {
    isLoading.value = true; // Mostramos indicador de carga

    try {
      final account = await AuthApi.signInWithGoogle();

      if (account != null) {
        currentUser.value = account;

        // Aquí podrías enviar un token a tu backend propio si lo tuvieras
        // final authentication = await account.authentication;
        // final idToken = authentication.idToken;

        Get.offAll(() => const HomeScreen());
      }
    } finally {
      isLoading.value =
          false; // Ocultamos indicador de carga independientemente del resultado
    }
  }

  /// Método para iniciar sesión con correo y contraseña
  Future<void> loginWithEmail(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Por favor ingresa correo y contraseña",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final data = await AuthApi.loginWithEmail(email, password);
      if (data != null) {
        token.value = data['token'];
        final user = data['user'] ?? {};
        userData.value = Map<String, dynamic>.from(user);
        userId.value = user['id'];
        roles.value = user['roles'] ?? [];

        Get.offAll(() => const HomeScreen());
      } else {
        Get.snackbar(
          "Error",
          "Credenciales incorrectas o error en el servidor",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Método para cerrar sesión
  Future<void> logout() async {
    isLoading.value = true;
    try {
      await AuthApi.signOut();
      currentUser.value = null;
      token.value = null;
      userData.clear();
      roles.clear();
      userId.value = null;
      Get.offAll(() => const HomeScreen());
    } finally {
      isLoading.value = false;
    }
  }

  // Helpers para acceder a información unificada desde cualquier pantalla
  bool get isLoggedIn => currentUser.value != null || token.value != null;
  String get displayName =>
      currentUser.value?.displayName ?? userData['nombre'] ?? 'Usuario';
  String get displayEmail =>
      currentUser.value?.email ?? userData['correo'] ?? '';
  String? get displayPhoto => currentUser.value?.photoUrl;
}
