import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      body: IntroductionScreen(
        pages: controller.pages.map((page) {
          return PageViewModel(
            title: page.title,
            body: page.body,
            image: Center(
              child: Icon(
                page.icon,
                size: 175.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
            decoration: const PageDecoration(
              titleTextStyle: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
              bodyTextStyle: TextStyle(fontSize: 18.0),
              imagePadding: EdgeInsets.all(24),
            ),
          );
        }).toList(),
        onDone: () {
          controller.completeOnboarding();
          Get.offAllNamed('/home');
          // Get.offAll(() => const HomeScreen());
        },
        onSkip: () {
          controller.completeOnboarding();
          Get.offAllNamed('/home');
        },
        showSkipButton: true,
        skip: const Text("Saltar"),
        next: const Icon(Icons.arrow_forward),
        done: const Text(
          "Entrar",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Theme.of(context).primaryColor,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
    );
  }
}
