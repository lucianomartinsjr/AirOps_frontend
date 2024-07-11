import 'package:flutter/material.dart';

class ApiService extends ChangeNotifier {
  Future<bool> checkEmail(String email) async {
    // Simule a verificação do e-mail com a API
    await Future.delayed(const Duration(seconds: 1));
    return false; // Retorne true se o e-mail já existir
  }

  Future<List<String>> fetchClasses() async {
    // Simule a busca de classes na API
    await Future.delayed(const Duration(seconds: 1));
    return ['Classe A', 'Classe B', 'Classe C'];
  }

  Future<List<String>> fetchModalities() async {
    // Simule a busca de modalidades na API
    await Future.delayed(const Duration(seconds: 1));
    return ['Modalidade 1', 'Modalidade 2', 'Modalidade 3'];
  }
}
