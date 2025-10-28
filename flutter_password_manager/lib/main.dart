import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_password_manager/core/auth_guard.dart';
import 'package:flutter_password_manager/firebase_options.dart';
import 'package:flutter_password_manager/screens/intro_screen.dart';
import 'package:flutter_password_manager/screens/routes.dart';
import 'package:flutter_password_manager/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AuthGuard(child: IntroScreen()),
      onGenerateRoute: Routes.generateRoute,  // ← IMPORTANTE
      debugShowCheckedModeBanner: false,
    );
  }
}
