import 'package:flutter/material.dart';
import 'package:flutter_password_manager/data/settings_repository.dart';
import 'package:flutter_password_manager/screens/routes.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/lottie/data_security.json',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    final repo = await SettingsRepository.create();
    final showIntro = await repo.getShowIntro();
    if (!mounted) return;
    if (showIntro) {
      Navigator.pushReplacementNamed(context, Routes.intro);
    } else {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }
}
