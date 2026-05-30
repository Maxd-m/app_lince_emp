import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import '../models/onboarding_model.dart';

class OnboardingController extends GetxController {
  final _box = GetStorage();
  final String _key = 'hasSeenOnboarding';

  final List<OnboardingPageData> pages = [
    OnboardingPageData(
      title: "¡Bienvenido a Lince Emp!",
      body:
          "La plataforma exclusiva para la comunidad del Tec para comprar y vender productos.",
      icon: Icons.school,
    ),
    OnboardingPageData(
      title: "Encuentra lo que buscas",
      body:
          "Descubre una gran variedad de productos ofrecidos por tus propios compañeros.",
      icon: Icons.shopping_bag,
    ),
    OnboardingPageData(
      title: "Apoya el emprendimiento",
      body:
          "Impulsa la economía local comprando a vendedores de confianza dentro de tu campus.",
      icon: Icons.favorite,
    ),
    OnboardingPageData(
      title: "Seguridad y Confianza",
      body:
          "Transacciones seguras y directas. ¡Regístrate y comienza tu experiencia!",
      icon: Icons.verified_user,
    ),
  ];

  void completeOnboarding() {
    _box.write(_key, true);
  }
}
