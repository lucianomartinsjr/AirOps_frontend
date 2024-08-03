import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/class.dart';
import '../models/modality.dart';
import '../models/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String baseUrl = 'http://localhost:3000';

  Future<bool> checkEmail(String email) async {
    final url = Uri.parse('$baseUrl/auth/validar-email');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      return false;
    } else if (response.statusCode == 400) {
      return true;
    } else {
      throw Exception('Erro ao verificar email: ${response.statusCode}');
    }
  }

  Future<List<Class>> fetchClasses() async {
    final url = Uri.parse('$baseUrl/classes-operadores');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Class.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao buscar classes: ${response.statusCode}');
    }
  }

  Future<List<Modality>> fetchModalities() async {
    final url = Uri.parse('$baseUrl/modalidades-jogos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Modality.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao buscar modalidades: ${response.statusCode}');
    }
  }

  Future<List<String>> fetchGames() async {
    final url = Uri.parse('$baseUrl/games');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return List<String>.from(responseBody['games']);
    } else {
      throw Exception('Não foi possível carregar as classes');
    }
  }

  Future<List<String>> fetchUsers() async {
    final url = Uri.parse('$baseUrl/users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return List<String>.from(responseBody['users']);
    } else {
      throw Exception('Não foi possível carregar os usuários');
    }
  }

  Future<Profile> fetchProfile() async {
    final url = Uri.parse('$baseUrl/operador');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${await _storage.read(key: 'jwt_token')}',
    });

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return Profile.fromJson(responseBody['profile']);
    } else {
      throw Exception('Occorreu um erro ao carregar o perfil');
    }
  }

  Future<bool> updateProfile(Profile profile) async {
    final url = Uri.parse('$baseUrl/profile');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${await _storage.read(key: 'jwt_token')}',
      },
      body: jsonEncode(profile.toJson()),
    );

    return response.statusCode == 200;
  }

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/entrar');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'email': email, 'senha': password}),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      await _storage.write(key: 'jwt_token', value: responseBody['token']);
      await _storage.write(
          key: 'isAdmin', value: responseBody['isAdmin'].toString());
      await _storage.write(
          key: 'hasToChangePassword',
          value: responseBody['hasToChangePassword'].toString());
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required String nickname,
    required String city,
    required String phone,
    required int? idClasseOperador,
    required List<int> modalityIds,
  }) async {
    final url = Uri.parse('$baseUrl/auth/cadastrar');
    final body = jsonEncode({
      'email': email,
      'senha': password,
      'nome': name,
      'apelido': nickname,
      'cidade': city,
      'contato': phone,
      'idClasseOperador': idClasseOperador,
      'modalidades': modalityIds,
    });
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: body,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        await _storage.write(key: 'jwt_token', value: responseBody['token']);
        await _storage.write(
            key: 'is_admin', value: responseBody['isAdmin'].toString());
        return {'success': true};
      } else {
        final responseBody = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseBody['message'] ?? 'Erro desconhecido'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message':
            'Erro na conexão com o servidor. Por favor, tente novamente mais tarde.'
      };
    }
  }

  Future<void> clearToken() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'isAdmin');
  }
}
