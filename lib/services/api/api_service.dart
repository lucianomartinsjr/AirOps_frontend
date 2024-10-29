import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logging/logging.dart';
import '../../models/class.dart';
import '../../models/game.dart';
import '../../models/modality.dart';
import '../../models/profile.dart';
import '../../constants/api_contants.dart';
import '../../models/user.dart';

class ApiService extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String baseUrl = ApiConstants.baseUrl;
  final Logger _logger = Logger('ApiService');

  Future<bool> forgotPassword(String email) async {
    final url = Uri.parse('$baseUrl/auth/recuperar-senha');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        // Log de erro com a mensagem de resposta do servidor
        final responseBody = jsonDecode(response.body);
        _logger.warning(
            'Erro ao recuperar senha: ${response.statusCode} - ${responseBody['message']}');
        return false;
      }
    } catch (e) {
      // Tratamento de exceções e logging do erro
      _logger.severe('Exceção capturada ao tentar recuperar senha: $e');
      return false;
    }
  }

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

  Future<void> updateUser(User user) async {
    try {
      // Log do ID do usuário e status de admin
      _logger.info(
          'Tentando atualizar usuário - ID: ${user.id}, isAdmin: ${user.isAdmin}');

      final token = await _storage.read(key: 'jwt_token');
      // Verificar se o token existe
      if (token == null) {
        _logger.severe('Token não encontrado');
        throw Exception('Token de autenticação não encontrado');
      }
      _logger.info('Token obtido com sucesso');

      final url = Uri.parse('$baseUrl/usuarios/${user.id}/admin');
      _logger.info('URL da requisição: $url');

      final response = await http.patch(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      _logger.info('Status code: ${response.statusCode}');
      _logger.info('Resposta do servidor: ${response.body}');

      if (response.statusCode != 200) {
        _logger.severe(
            'Erro na resposta: ${response.statusCode} - ${response.body}');
        throw Exception('Falha ao atualizar usuário: ${response.statusCode}');
      }

      _logger.info('Usuário atualizado com sucesso');
    } catch (e) {
      _logger.severe('Exceção ao atualizar usuário: $e');
      throw Exception('Erro ao atualizar usuário: $e');
    }
  }

  Future<List<User>> fetchUsers() async {
    final url = Uri.parse('$baseUrl/operador/admin');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${await _storage.read(key: 'jwt_token')}',
    });
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => User.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load users');
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

  Future<List<Game>> fetchAdminGames() async {
    final url = Uri.parse('$baseUrl/eventos/admin');

    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token == null) {
        throw Exception('Token JWT não encontrado');
      }

      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Game.fromJson(item)).toList();
      } else {
        throw Exception(
            'Não foi possível carregar os jogos. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar jogos: $e');
    }
  }

  Future<Map<String, dynamic>> fetchProfile() async {
    final url = Uri.parse('$baseUrl/operador');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${await _storage.read(key: 'jwt_token')}',
    });

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody;
    } else {
      throw Exception('Ocorreu um erro ao carregar o perfil');
    }
  }

  Future<bool> updateProfile(Profile profile) async {
    final url = Uri.parse('$baseUrl/operador/update-profile');
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

  Future<bool> changePassword(String newPassword) async {
    final url = Uri.parse('$baseUrl/auth/alterar-senha');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${await _storage.read(key: 'jwt_token')}',
      },
      body: jsonEncode({
        'novaSenha': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      await _storage.write(key: 'hasToChangePassword', value: 'false');
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateModality(Modality modality) async {
    try {
      final url = Uri.parse('$baseUrl/modalidades-jogos/${modality.id}');
      _logger.info('Request URL: $url');

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${await _storage.read(key: 'jwt_token')}',
      };
      _logger.info('Request Headers: $headers');
      _logger.info('Modality active value before request: ${modality.ativo}');

      final body = jsonEncode(modality.toJson());
      _logger.info('Request Body: $body');

      final response = await http.patch(
        url,
        headers: headers,
        body: body,
      );

      _logger.info('Response Status Code: ${response.statusCode}');
      _logger.info('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        _logger.warning('Erro ao atualizar modalidade: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _logger.severe('Exception caught: $e');
      return false;
    }
  }

  Future<bool> createModality(Modality modality) async {
    final url = Uri.parse('$baseUrl/modalidades-jogos');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${await _storage.read(key: 'jwt_token')}',
      },
      body: jsonEncode(modality.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Erro ao criar modalidade: ${response.statusCode}');
    }
  }

  Future<bool> createClass(Class classe) async {
    try {
      final url = Uri.parse('$baseUrl/classes-operadores');
      final token = await _storage.read(key: 'jwt_token');

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      };
      final body = jsonEncode(classe.toJson());

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        _logger.warning('Erro ao criar classe: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _logger.severe('Erro ao criar classe: $e');
      return false;
    }
  }

  Future<bool> updateClass(Class classe) async {
    if (classe.id == null) {
      _logger.warning('Erro: O ID da classe não pode ser nulo ao atualizar.');
      return false;
    }

    try {
      final url = Uri.parse('$baseUrl/classes-operadores/${classe.id}');
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${await _storage.read(key: 'jwt_token')}',
      };
      final body = jsonEncode(classe.toJson());

      final response = await http.patch(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        _logger.warning('Erro ao atualizar classe: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _logger.severe('Erro ao atualizar classe: $e');
      return false;
    }
  }

  Future<void> clearToken() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'isAdmin');
  }
}
