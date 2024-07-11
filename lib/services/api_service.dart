import 'package:flutter/material.dart';

class Modality {
  final String id;
  final String name;

  Modality(this.id, this.name);
}

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

  Future<List<Modality>> fetchModalities() async {
    // Simule a busca de modalidades na API
    await Future.delayed(const Duration(seconds: 1));
    // Retorne uma lista de objetos Modality
    return [
      Modality('1', 'Modalidade 1'),
      Modality('2', 'Modalidade 2'),
      Modality('3', 'Modalidade 3'),
    ];
  }
}
