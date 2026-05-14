import 'package:flutter/material.dart';
import 'package:publicapi/screens/login_screen.dart';
import 'package:publicapi/screens/product_list_screen.dart';
import 'package:publicapi/services/session_manager.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _sessionManager = SessionManager();
  late Future<bool> _checkAuthFuture;

  @override
  void initState() {
    super.initState();
    _checkAuthFuture = _checkAuthentication();
  }

  Future<bool> _checkAuthentication() async {
    await _sessionManager.initialize();
    return _sessionManager.isAuthenticated();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAuthFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.data == true) {
          return ProductListScreen(autoLoad: true);
        }
        return const LoginScreen();
      },
    );
  }
}
