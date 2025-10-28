import 'package:flutter/material.dart';
import 'package:flutter_password_manager/screens/routes.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ Import necessário

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _dontShowAgain = false;
  bool _isLoading = true; // ✅ para mostrar tela branca enquanto verifica prefs

  @override
  void initState() {
    super.initState();
    _checkIfShouldSkipIntro();
  }

  Future<void> _checkIfShouldSkipIntro() async {
    final prefs = await SharedPreferences.getInstance();
    final skipIntro = prefs.getBool('skipIntro') ?? false;
    if (skipIntro && mounted) {
      // ✅ pula direto para a home
      Navigator.pushReplacementNamed(context, Routes.home);
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isLastPage = _currentPage == _pages.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Conteúdo da introdução
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Expanded(child: Lottie.asset(page['lottie']!)),
                        Text(
                          page['title']!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          page['subtitle']!,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Checkbox de "não mostrar novamente"
            if (isLastPage)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: _dontShowAgain,
                      onChanged: (val) {
                        setState(() {
                          _dontShowAgain = val ?? false;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text('Não mostrar essa introdução novamente.'),
                    ),
                  ],
                ),
              ),

            // Botões de navegação
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(onPressed: _onBack, child: const Text('Voltar'))
                  else
                    const SizedBox(width: 80),
                  TextButton(
                    onPressed: _onNext,
                    child: Text(isLastPage ? 'Concluir' : 'Avançar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _finishIntro();
    }
  }

  Future<void> _finishIntro() async {
    // ✅ grava a preferência no SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    if (_dontShowAgain) {
      await prefs.setBool('skipIntro', true);
    }
    if (mounted) {
      Navigator.pushReplacementNamed(context, Routes.home);
    }
  }

  void _onBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  final List<Map<String, String>> _pages = [
    {
      'title': 'Bem-vindo ao App',
      'subtitle': 'Aprenda a usar o app passo a passo.',
      'lottie': 'assets/lottie/forgot_password_animation.json',
    },
    {
      'title': 'Segurança garantida',
      'subtitle': 'Centralize suas senhas em um lugar seguro.',
      'lottie': 'assets/lottie/login_and_signup.json',
    },
    {
      'title': 'Comece Agora',
      'subtitle': 'Vamos começar a usar o app!',
      'lottie': 'assets/lottie/login_and_signup.json',
    },
  ];
}
