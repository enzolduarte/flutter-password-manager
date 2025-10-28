import 'package:firebase_auth/firebase_auth.dart'; // Biblioteca do Firebase Auth para autenticação de usuários
import 'package:flutter/material.dart'; // Biblioteca principal do Flutter para widgets e UI

// Tela de login com Firebase Authentication
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Chave do formulário para validação
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto para email e senha
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Controla se a senha está oculta ou visível
  bool _isObscure = true;

  // Controla se está carregando (para exibir CircularProgressIndicator)
  bool _isLoading = false;

  // Instância do FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50, // Cor de fundo da tela
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 6, // Sombra do card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey, // Associa a chave do formulário
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Ícone decorativo
                    const Icon(
                      Icons.lock_outline,
                      size: 80,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    // Título da tela
                    Text(
                      "Bem-vindo!",
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    // Subtítulo da tela
                    Text(
                      "Faça login para continuar",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 24),
                    // Campo de email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Preencha o e-mail' : null,
                    ),
                    const SizedBox(height: 16),
                    // Campo de senha
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isObscure, // Oculta ou mostra a senha
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Preencha à senha' : null,
                      decoration: InputDecoration(
                        labelText: "Senha",
                        prefixIcon: const Icon(Icons.lock_outline),
                        // Ícone para alternar visibilidade da senha
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure; // Alterna visibilidade
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Se estiver carregando, mostra indicador de progresso
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Column(
                            children: [
                              // Botão de login
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: _signIn, // Função de login
                                  child: const Text(
                                    "Entrar",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Botão de registro
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.blue,
                                    side: const BorderSide(
                                      color: Colors.blue,
                                      width: 2,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                  onPressed: _signUp, // Função de registro
                                  child: const Text("Registrar"),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Função para login com email e senha usando FirebaseAuth
  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true); // Inicia carregamento
      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } catch (e) {
        if (mounted) {
          // Mostra erro caso falhe o login
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Erro ao entrar: $e")));
        }
      } finally {
        setState(() => _isLoading = false); // Finaliza carregamento
      }
    }
  }

  /// 🔹 Função para registrar usuário com email e senha usando FirebaseAuth
  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true); // Inicia carregamento
      try {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } catch (e) {
        if (mounted) {
          // Mostra erro caso falhe o registro
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Erro ao registrar: $e")));
        }
      } finally {
        setState(() => _isLoading = false); // Finaliza carregamento
      }
    }
  }
}
