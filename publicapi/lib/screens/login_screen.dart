import 'package:flutter/material.dart';
import 'package:publicapi/services/auth_service.dart';
import 'package:publicapi/screens/auth_gate.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateUsername(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Informe o usuario.';
    if (text.length < 3) return 'Usuario deve ter ao menos 3 caracteres.';
    if (text.contains(' ')) return 'Usuario nao pode conter espacos.';
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Informe a senha.';
    if (text.length < 6) return 'Senha deve ter ao menos 6 caracteres.';
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    bool success = false;
    try {
      success = await _authService.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao conectar-se: $e';
      });
    }

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthGate()),
      );
    } else {
      setState(() {
        _errorMessage = 'Credenciais invalidas.';
      });
    }

    setState(() { _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
          children: [
            const SizedBox(height: 48),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
              validator: _validateUsername,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: _validatePassword,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading ? const CircularProgressIndicator() : const Text('Entrar'),
            ),
          ],
          ),
        ),
      ),
    );
  }
}
