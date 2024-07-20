import 'package:flutter/material.dart';

class AdminHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'lib/assets/images/logo.png', // Substitua pelo caminho do seu logotipo
          height: 200,
        ),
        const SizedBox(height: 10),
        const Text(
          'Painel Administrador',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ],
    );
  }
}
