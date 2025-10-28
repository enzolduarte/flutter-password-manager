import 'package:flutter/material.dart';
import 'package:flutter_password_manager/screens/home_screen.dart';
import 'package:flutter_password_manager/screens/intro_screen.dart';
import 'package:flutter_password_manager/screens/login_screen.dart';
import 'package:flutter_password_manager/screens/new_pass_screen.dart';

// Classe responsável por gerenciar todas as rotas do aplicativo
class Routes {
  // Definição das constantes de rotas para facilitar a navegação
  static const String splash = '/';       // Rota inicial (Splash Screen)
  static const String intro = '/intro';   // Rota da tela de introdução
  static const String home = '/home';     // Rota da tela principal (Home)
  static const String login = '/login';   // Rota da tela de login
  static const String new_pass = '/newpass'; // Rota da tela de criação/recuperação de senha

  // Método responsável por gerar a rota correspondente ao nome fornecido
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case intro:
        // Retorna a tela de introdução
        return MaterialPageRoute(builder: (_) => IntroScreen());
      case home:
        // Retorna a tela principal
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case login:
        // Retorna a tela de login
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case new_pass:
        // Retorna a tela de criação ou recuperação de senha
        return MaterialPageRoute(builder: (_) => NewPasswordScreen());
      default:
        // Rota padrão para nomes de rota não encontrados
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text('Rota não encontrada!'))),
        );
    }
  }
}
