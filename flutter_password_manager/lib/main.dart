// Importa o núcleo do Firebase, necessário para inicializar o Firebase no app.
import 'package:firebase_core/firebase_core.dart';

// Importa o pacote principal do Flutter, com widgets, temas, etc.
import 'package:flutter/material.dart';

// Importa o AuthGuard, que deve verificar se o usuário está logado antes de mostrar a tela principal.
import 'package:flutter_password_manager/core/auth_guard.dart';

// Importa as opções de configuração do Firebase (geradas automaticamente pelo comando `flutterfire configure`).
import 'package:flutter_password_manager/firebase_options.dart';

// Importa a tela de introdução, que será exibida ao abrir o app pela primeira vez.
import 'package:flutter_password_manager/screens/intro_screen.dart';

// Importa o gerenciador de rotas do app, que define as telas e suas navegações.
import 'package:flutter_password_manager/screens/routes.dart';



// A função principal do app — ponto de entrada da aplicação Flutter.
Future<void> main() async {
  // Garante que o Flutter esteja totalmente inicializado antes de executar qualquer operação assíncrona.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase com as configurações corretas para a plataforma (Android, iOS, Web...).
  // Isso é obrigatório antes de usar qualquer serviço do Firebase (Auth, Firestore, etc.).
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inicia o aplicativo chamando o widget raiz `MyApp`.
  runApp(const MyApp());
}


// O widget principal da aplicação — define tema, título, rotas e tela inicial.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Define o título da aplicação (usado por alguns sistemas e em multitarefa).
      title: 'Flutter Demo',

      // Define o tema visual do app (cores, tipografia, etc.).
      theme: ThemeData(
        // Cria um esquema de cores a partir de uma cor base (deepPurple).
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      // Define a tela inicial do app.
      // O AuthGuard é usado para verificar se o usuário está autenticado:
      //  - Se estiver logado, ele mostra a tela protegida (ex: HomeScreen).
      //  - Se não estiver logado, ele mostra a tela de login.
      // Aqui, ele recebe a IntroScreen como “filho padrão” (caso nenhum login esteja ativo).
      home: const AuthGuard(child: IntroScreen()),

      // Define como as rotas (telas) são geradas e navegadas dentro do app.
      // Essa função `generateRoute` é usada para criar navegações nomeadas.
      onGenerateRoute: Routes.generateRoute,

      // Remove a faixa de “debug” no canto superior direito durante o desenvolvimento.
      debugShowCheckedModeBanner: false,
    );
  }
}
