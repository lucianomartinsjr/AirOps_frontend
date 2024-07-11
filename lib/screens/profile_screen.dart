import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF222222),
      body: Center(
        child: Text('Tela do Perfil',
            style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    );
  }
}
