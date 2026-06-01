import 'package:flutter/material.dart';
import 'package:app_lince_emp/screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_lince_emp/screens/login_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:app_lince_emp/screens/onboarding_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // print("Notificación en segundo plano: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configurar el handler de segundo plano
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Inicializa el almacenamiento local para el caché y la sesión
  await GetStorage.init();

  try {
    // 4. Carga el archivo .env de tus assets
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Error cargando el archivo .env: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override

  void initState()
  {
    super.initState();
    _setupInteractedMessages();
  }
  Future<void> _setupInteractedMessages() async {
    // 1. Obtener el Token (esto sí puede ser async aquí)
  String? token = await FirebaseMessaging.instance.getToken();
    // 1. Solicitar permisos (Vital para iOS y Android 13+)
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    // 3. Suscribirse al tema (Rúbrica: Tema de interés)
  await messaging.subscribeToTopic('avisos');
    // 2. Escuchar notificaciones en PRIMER PLANO (Cualquier pantalla)
    // Esto cumple: "Las notificaciones se deberán poder escuchar en cualquier pantalla"
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Tip Pro: Usa Get.snackbar para mostrar la notificación al usuario
      // ya que estás usando GetX.
      Get.snackbar(
        message.notification?.title ?? "Nueva notificación",
        message.notification?.body ?? "",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blueGrey.withOpacity(0.8),
        colorText: Colors.white,
      );
    });

    // 3. Suscribirse a un tema automáticamente (opcional o mediante un botón)
    // Esto cumple: "La app podrá suscribirse a un tema de interés"
    await messaging.subscribeToTopic('anuncios_generales');
  }
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
      home: hasSeenOnboarding ? const HomeScreen() : const OnboardingScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
