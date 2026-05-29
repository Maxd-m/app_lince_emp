// lib/controllers/auth_controller.dart

import 'package:app_lince_emp/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../api/auth_api.dart';
import '../screens/google_register_screen.dart';

class AuthController extends GetxController {
  final _box = GetStorage();

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

  // 1. Una palabra clave secreta que solo tu app conoce
  final String _secretKey = "L1nc3Emp_Secr3t_2026!";

  // Helper para generar la contraseña única de Google de forma segura
  String _generateGooglePassword(String email, String googleId) {
    return "${email}_${googleId}_$_secretKey";
  }

  @override
  void onInit() {
    super.onInit();
    _loadSession();
  }

  // Helper interno para no repetir código al guardar los datos del usuario
  void _processAuthSuccess(Map<String, dynamic> data) {
    token.value = data['token'];
    final user = data['user'] ?? {};
    userData.value = Map<String, dynamic>.from(user);
    userId.value = user['id'];
    roles.value = user['roles'] ?? [];

    // Guardar datos para persistencia
    _box.write('token', token.value);
    _box.write('userData', userData.value);
    _box.write('userId', userId.value);
    _box.write('roles', roles.value);
  }

  void _loadSession() {
    final savedToken = _box.read('token');
    if (savedToken != null) {
      token.value = savedToken;
      final savedUser = _box.read('userData');
      if (savedUser != null) {
        userData.value = Map<String, dynamic>.from(savedUser);
      }
      userId.value = _box.read('userId');
      roles.value = _box.read('roles') ?? [];
    }
  }

  /// Método para iniciar sesión con google
  Future<void> login() async {
    isLoading.value = true;

    try {
      final account = await AuthApi.signInWithGoogle();

      if (account != null) {
        currentUser.value = account;

        // Generamos la contraseña determinista
        final passwordFake = _generateGooglePassword(account.email, account.id);

        // Intentamos iniciar sesión en tu backend con los datos de Google
        final data = await AuthApi.loginWithEmail(account.email, passwordFake);

        if (data != null) {
          // CASO A: Ya existía en la BD, entramos directo
          _processAuthSuccess(data);
          Get.offAll(() => const HomeScreen());
        } else {
          // CASO B: No existe en la BD, lo mandamos al formulario simplificado
          Get.to(() => const GoogleRegisterScreen());
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Método adaptado para registrar usuarios de Google
  Future<void> registerGoogleUser({
    required String telefono,
    required String carrera,
    required bool isVendor,
  }) async {
    final account = currentUser.value;
    if (account == null) return;

    if (telefono.isEmpty || carrera.isEmpty) {
      Get.snackbar(
        "Error",
        "Por favor completa los campos faltantes",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final passwordFake = _generateGooglePassword(account.email, account.id);
      final List<int> idRol = isVendor ? [2, 3] : [3];

      final data = await AuthApi.register(
        nombre: account.displayName ?? 'Usuario Google',
        correo: account.email,
        password: passwordFake,
        passwordConfirmation: passwordFake, // Coinciden automáticamente
        telefono: telefono,
        carrera: carrera,
        idRol: idRol,
      );

      if (data != null) {
        _processAuthSuccess(data);
        Get.snackbar("Éxito", "Cuenta vinculada y creada con éxito");
        Get.offAll(() => const HomeScreen());
      }
    } finally {
      isLoading.value = false;
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
        _processAuthSuccess(data);
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

  /// Método para registrarse
  Future<void> register({
    required String nombre,
    required String correo,
    required String password,
    required String passwordConfirmation,
    required String telefono,
    required String carrera,
    required bool isVendor,
  }) async {
    if (nombre.isEmpty ||
        correo.isEmpty ||
        password.isEmpty ||
        telefono.isEmpty ||
        carrera.isEmpty) {
      Get.snackbar(
        "Error",
        "Por favor completa todos los campos",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password != passwordConfirmation) {
      Get.snackbar(
        "Error",
        "Las contraseñas no coinciden",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final List<int> idRol = isVendor ? [2, 3] : [3];
      final data = await AuthApi.register(
        nombre: nombre,
        correo: correo,
        password: password,
        passwordConfirmation: passwordConfirmation,
        telefono: telefono,
        carrera: carrera,
        idRol: idRol,
      );

      if (data != null) {
        _processAuthSuccess(data);
        Get.snackbar("Éxito", "Cuenta creada exitosamente");
        Get.offAll(() => const HomeScreen());
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
      _box.erase(); // Limpiar almacenamiento local
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

  /// Verifica si el usuario tiene el rol de vendedor (ID 2)
  bool get isVendor {
    if (roles.isEmpty) return false;
    return roles.any((role) {
      if (role is int) return role == 2;
      if (role is Map) return role['id'] == 2;
      return false;
    });
  }
}
