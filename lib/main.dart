import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app_lince_emp/screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_lince_emp/screens/login_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:app_lince_emp/screens/onboarding_screen.dart';
import 'package:showcaseview/showcaseview.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DESCOMENTA ESTA LÍNEA SOLO UNA VEZ PARA LIMPIAR LA MEMORIA:
  await GetStorage().erase();

  // Inicializa el almacenamiento local para el caché y la sesión
  await GetStorage.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    // 4. Carga el archivo .env de tus assets
    await dotenv.load(fileName: ".env");
    print("¡Archivo .env cargado con éxito!");
  } catch (e) {
    print("Error cargando el archivo .env: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final bool hasSeenOnboarding = box.read('hasSeenOnboarding') ?? false;

    return GetMaterialApp(
      title: 'Lince emp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      // SOLUCIÓN GLOBAL: Inyectamos el ShowCaseWidget en la raíz de la navegación.
      // Esto envuelve de forma automática a CUALQUIER pantalla de la app.
      builder: (context, child) {
        return ShowCaseWidget(builder: (showcaseContext) => child!);
      },

      home: hasSeenOnboarding ? const HomeScreen() : const OnboardingScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
