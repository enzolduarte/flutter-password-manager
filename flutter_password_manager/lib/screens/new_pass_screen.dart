import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

// Tela para geração e salvamento de nova senha
class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({Key? key}) : super(key: key);

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  // Configurações iniciais de geração de senha
  double _length = 12;           // Tamanho da senha
  bool _includeUpper = true;     // Incluir letras maiúsculas
  bool _includeLower = true;     // Incluir letras minúsculas
  bool _includeNumbers = true;   // Incluir números
  bool _includeSymbols = false;  // Incluir símbolos
  bool _isExpanded = false;      // Estado do painel de configurações
  String? _generatedPassword;    // Senha gerada
  bool _loading = false;         // Estado de carregamento

  // URL da API que gera a senha
  final String _apiUrl = 'https://safekey-api-a1bd9aa97953.herokuapp.com/generate';

  /// 🔹 Função para gerar senha via API
  Future<void> _generatePassword() async {
    setState(() => _loading = true); // Inicia carregamento
    try {
      final uri = Uri.parse(_apiUrl);
      final response = await http.post(
        uri,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "length": _length.toInt(),
          "includeLowercase": _includeLower,
          "includeUppercase": _includeUpper,
          "includeNumbers": _includeNumbers,
          "includeSymbols": _includeSymbols,
        }),
      );

      if (response.statusCode == 200) {
        // Se a API retornar sucesso, salva a senha gerada
        final data = jsonDecode(response.body);
        setState(() {
          _generatedPassword = data['password'] ?? 'Erro ao gerar senha';
        });
      } else {
        // Exibe erro caso o status não seja 200
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ${response.statusCode}: Falha ao gerar senha.')),
        );
      }
    } catch (e) {
      // Captura e exibe exceções
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } finally {
      setState(() => _loading = false); // Finaliza carregamento
    }
  }

  /// 🔹 Função para salvar senha no Firestore
  Future<void> _savePassword() async {
    if (_generatedPassword == null) {
      // Se não houver senha gerada, avisa o usuário
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gere uma senha primeiro.')),
      );
      return;
    }

    final controller = TextEditingController();
    // Solicita ao usuário um rótulo para a senha
    final label = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Salvar senha'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Rótulo da senha',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancela
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text), // Salva
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (label != null && label.isNotEmpty) {
      try {
        // Verifica se usuário está autenticado
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuário não autenticado. Faça login novamente.')),
          );
          return;
        }

        // Salva a senha no Firestore na coleção do usuário
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('passwords')
            .add({
          'title': label,
          'password': _generatedPassword,
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✓ Senha salva com sucesso!')),
          );
          Navigator.pop(context); // Fecha a tela e retorna à Home
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      }
    }
  }

  // 🔹 Exibe informações sobre o app
  void _showInfo() {
    showAboutDialog(
      context: context,
      applicationName: 'SafeKey - Gerador de Senhas',
      applicationVersion: '1.0.0',
      children: const [
        Text('Este app gera e salva senhas seguras usando o Firestore.'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Senha'),
        actions: [
          IconButton(icon: const Icon(Icons.info_outline), onPressed: _showInfo),
        ],
      ),
      // Botão flutuante para salvar a senha
      floatingActionButton: FloatingActionButton(
        onPressed: _savePassword,
        child: const Icon(Icons.save),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Painel expansível para configurações da senha
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: ExpansionPanelList(
                expansionCallback: (index, isExpanded) {
                  setState(() => _isExpanded = !_isExpanded);
                },
                animationDuration: const Duration(milliseconds: 500),
                children: [
                  ExpansionPanel(
                    headerBuilder: (context, isExpanded) =>
                        const ListTile(title: Text('Configurações de geração')),
                    body: Column(
                      children: [
                        // Tamanho da senha
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Tamanho:'),
                            Text(_length.toInt().toString()),
                          ],
                        ),
                        Slider(
                          value: _length,
                          min: 4,
                          max: 64,
                          divisions: 60,
                          label: _length.toInt().toString(),
                          onChanged: (v) => setState(() => _length = v),
                        ),
                        // Opções de inclusão de caracteres
                        SwitchListTile(
                          title: const Text('Letras maiúsculas'),
                          value: _includeUpper,
                          onChanged: (v) => setState(() => _includeUpper = v),
                        ),
                        SwitchListTile(
                          title: const Text('Letras minúsculas'),
                          value: _includeLower,
                          onChanged: (v) => setState(() => _includeLower = v),
                        ),
                        SwitchListTile(
                          title: const Text('Números'),
                          value: _includeNumbers,
                          onChanged: (v) => setState(() => _includeNumbers = v),
                        ),
                        SwitchListTile(
                          title: const Text('Símbolos'),
                          value: _includeSymbols,
                          onChanged: (v) => setState(() => _includeSymbols = v),
                        ),
                      ],
                    ),
                    isExpanded: _isExpanded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Botão para gerar senha
            ElevatedButton.icon(
              onPressed: _loading ? null : _generatePassword,
              icon: const Icon(Icons.refresh),
              label: _loading
                  ? const Text('Gerando...')
                  : const Text('Gerar senha'),
            ),
            const SizedBox(height: 24),
            // Exibe a senha gerada, se houver
            if (_generatedPassword != null)
              PasswordResultWidget(password: _generatedPassword!),
          ],
        ),
      ),
    );
  }
}

// Widget para exibir senha gerada com opção de copiar
class PasswordResultWidget extends StatelessWidget {
  final String password;
  const PasswordResultWidget({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Exibe senha selecionável
            Expanded(
              child: SelectableText(
                password,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Botão para copiar senha
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: password));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Senha copiada!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
