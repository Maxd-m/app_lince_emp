// lib/controllers/auth_controller.dart

import 'package:app_lince_emp/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../api/auth_api.dart';

class AuthController extends GetxController {
  // Variable reactiva para almacenar el usuario de Google
  // Usamos Rxn para indicar que puede ser nulo
  final Rxn<GoogleSignInAccount> currentUser = Rxn<GoogleSignInAccount>();

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

        // TODO: Navegar a tu pantalla principal
        // Get.offAllNamed('/home');
        Get.offAll(() => const HomeScreen());
      }
    } finally {
      isLoading.value =
          false; // Ocultamos indicador de carga independientemente del resultado
    }
  }

  /// Método para cerrar sesión
  Future<void> logout() async {
    isLoading.value = true;
    try {
      await AuthApi.signOut();
      currentUser.value = null;
      Get.offAll(() => const HomeScreen());
    } finally {
      isLoading.value = false;
    }
  }
}
