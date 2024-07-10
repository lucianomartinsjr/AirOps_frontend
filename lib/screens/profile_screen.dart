import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      body: const Center(
        child: Text('Tela de Perfil',
            style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    );
  }
}
