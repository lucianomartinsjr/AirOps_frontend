import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'auth/login/login_screen.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _initializeApp();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    // Garante que a tela de splash seja exibida por pelo menos 3 segundos
    await Future.wait([
      _checkInternetConnection(),
      Future.delayed(const Duration(seconds: 3)),
    ]);
  }

  Future<void> _checkInternetConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        _showNoInternetDialog();
      } else {
        _navigateToLogin();
      }
    } catch (e) {
      _showErrorDialog("Erro ao verificar a conexão");
    }
  }

  void _showNoInternetDialog() {
    _showDialog(
      "Sem conexão com a Internet",
      "Por favor, verifique sua conexão e tente novamente.",
    );
  }

  void _showErrorDialog(String message) {
    _showDialog("Erro", message);
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(color: Colors.white)),
          content: Text(content, style: const TextStyle(color: Colors.white70)),
          backgroundColor: Colors.grey[900],
          actions: <Widget>[
            TextButton(
              child: const Text("Tentar novamente",
                  style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                Navigator.of(context).pop();
                _checkInternetConnection();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'NotoSans',
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
        scaffoldBackgroundColor: const Color(0xFF222222),
      ),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _animation,
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 300,
                  semanticLabel: 'Logo do aplicativo',
                ),
              ),
              const SizedBox(height: 50),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
              const SizedBox(height: 20),
              const Text(
                "Carregando...",
                style: TextStyle(fontSize: 18, color: Colors.white),
                semanticsLabel: 'Carregando o aplicativo',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
