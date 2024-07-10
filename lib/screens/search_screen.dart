import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      body: const Center(
        child: Text('Tela de Busca',
            style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    );
  }
}
