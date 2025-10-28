import 'package:flutter/material.dart';

class NewPassScreen extends StatelessWidget {
  const NewPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Senha')),
      body: const Center(child: Text('Tela Nova Senha')),
    );
  }
}
