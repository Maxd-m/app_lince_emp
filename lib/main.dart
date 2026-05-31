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
  // await GetStorage().erase();

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
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        // colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      // ignore: deprecated_member_use
      home: hasSeenOnboarding
          ? ShowCaseWidget(builder: (context) => const HomeScreen())
          : const OnboardingScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
