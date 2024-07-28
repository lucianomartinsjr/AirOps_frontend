import 'package:flutter/material.dart';

class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 200,
        ),
        const SizedBox(height: 10),
        const Text(
          'Painel do Administrador',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ],
    );
  }
}
