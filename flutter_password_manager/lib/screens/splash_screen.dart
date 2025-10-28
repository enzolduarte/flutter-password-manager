// Importa os pacotes necessários
import 'package:flutter/material.dart';
// Importa o repositório responsável por salvar e recuperar configurações locais (SharedPreferences)
import 'package:flutter_password_manager/data/settings_repository.dart';
// Importa o gerenciador de rotas da aplicação
import 'package:flutter_password_manager/screens/routes.dart';
// Importa o pacote de animações Lottie (animações em JSON)
import 'package:lottie/lottie.dart';


// Tela de splash — exibida brevemente ao iniciar o aplicativo.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


// Estado da SplashScreen (permite executar ações assíncronas, como carregar dados ou navegar)
class _SplashScreenState extends State<SplashScreen> {

  // Método chamado automaticamente quando o widget é inserido na árvore de widgets.
  @override
  void initState() {
    super.initState();
    _navigate(); // Inicia o processo de navegação assim que a tela é carregada.
  }

  // Constrói a interface visual da tela.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // O Scaffold fornece a estrutura básica da tela (corpo, appbar, etc.)
      body: Center(
        // Centraliza o conteúdo no meio da tela
        child: Lottie.asset(
          // Animação exibida no splash (arquivo dentro de /assets/lottie/)
          'assets/lottie/data_security.json',
          width: 200,
          height: 200,
          fit: BoxFit.contain, // Mantém a proporção dentro do tamanho definido
        ),
      ),
    );
  }

  // Método responsável por decidir para qual tela o app vai após o splash.
  Future<void> _navigate() async {
    // Aguarda 2 segundos (tempo para a animação aparecer na tela)
    await Future.delayed(const Duration(seconds: 2));

    // Cria ou acessa o repositório de configurações locais (SharedPreferences)
    final repo = await SettingsRepository.create();

    // Recupera o valor salvo que indica se o usuário deve ver a tela de introdução
    final showIntro = await repo.getShowIntro();

    // Garante que o widget ainda está montado na tela antes de navegar (evita erro se a tela for destruída)
    if (!mounted) return;

    // Se o usuário ainda deve ver a introdução → vai para a tela de introdução
    if (showIntro) {
      Navigator.pushReplacementNamed(context, Routes.intro);
    } 
    // Caso contrário → vai direto para a tela de login
    else {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }
}
