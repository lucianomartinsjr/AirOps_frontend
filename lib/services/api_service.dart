import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/modality.dart';
import '../models/profile.dart';

class ApiService extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

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
      Modality(id: '1', name: 'Modalidade 1'),
      Modality(id: '2', name: 'Modalidade 2'),
      Modality(id: '3', name: 'Modalidade 3'),
    ];
  }

  Future<Profile> fetchProfile() async {
    // Simule a busca do perfil na API
    await Future.delayed(const Duration(seconds: 1));
    // Retorne um perfil simulado
    return Profile(
      name: 'John Doe',
      nickname: 'Johnny',
      city: 'Springfield',
      phone: '(64)9 9999-9999',
      className: 'Classe A',
      modalityIds: ['1', '2'],
    );
  }

  Future<bool> updateProfile(Profile profile) async {
    // Simule a atualização do perfil na API
    await Future.delayed(const Duration(seconds: 1));
    // Aqui você pode adicionar lógica para atualizar o perfil se necessário
    // Para simulação, apenas retorne true para indicar sucesso
    return true;
  }

  Future<bool> login(String email, String password) async {
    // Simule o login na API e o recebimento de um token JWT
    await Future.delayed(const Duration(seconds: 1));
    String token = 'simulated_jwt_token';

    // Armazene o token JWT de forma segura
    await _storage.write(key: 'jwt_token', value: token);

    return true;
  }

  Future<void> clearToken() async {
    // Limpe o token JWT armazenado de forma segura
    await _storage.delete(key: 'jwt_token');
  }
}
