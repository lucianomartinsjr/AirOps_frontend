import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../../models/game.dart';

class AirsoftService with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _baseUrl = 'http://localhost:3000';

  List<Game> _games = [];
  List<Game> _filteredGames = [];
  List<Game> _subscribedGames = [];
  List<Game> _organizerGames = [];
  List<Game> _gameHistory =
      []; // Nova lista para armazenar o histórico de jogos

  List<Game> get games => _filteredGames.isNotEmpty ? _filteredGames : _games;
  List<Game> get subscribedGames => _subscribedGames;
  List<Game> get organizerGames => _organizerGames;
  List<Game> get gameHistory =>
      _gameHistory; // Corrigido para retornar a lista de histórico

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<void> addGame(Game game, BuildContext context) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/eventos/criar'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(game.toJson()),
      );

      if (response.statusCode == 201) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Jogo criado com sucesso!')),
          );
        }
      } else {
        throw Exception('Erro ao adicionar jogo');
      }
    } catch (e) {
      debugPrint('Erro ao adicionar jogo: $e');
    }
  }

  Future<void> fetchGames() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final response = await http.get(
        headers: {'Authorization': 'Bearer $token'},
        Uri.parse('$_baseUrl/eventos'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _games = data.map((json) => Game.fromJson(json)).toList();
        _filteredGames = [];
        notifyListeners();
      } else {
        throw Exception('Erro ao buscar jogos');
      }
    } catch (e) {
      debugPrint('Erro ao buscar jogos: $e');
    }
  }

  Future<void> fetchSubscribedGames() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/eventos'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _subscribedGames = data
            .map((json) => Game.fromJson(json))
            .where((game) => game.inscrito == true)
            .toList();
        notifyListeners();
      } else {
        throw Exception('Erro ao buscar jogos inscritos');
      }
    } catch (e) {
      debugPrint('Erro ao buscar jogos inscritos: $e');
    }
  }

  Future<void> fetchOrganizerGames() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/eventos/organizados-operador'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _organizerGames = data.map((json) => Game.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Erro ao buscar jogos organizados pelo jogador');
      }
    } catch (e) {
      debugPrint('Erro ao buscar jogos organizados pelo jogador: $e');
    }
  }

  Future<void> updateGame(int id, Game updatedGame) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final response = await http.put(
        Uri.parse('$_baseUrl/games/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(updatedGame.toJson()),
      );

      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        throw Exception('Erro ao atualizar jogo');
      }
    } catch (e) {
      debugPrint('Erro ao atualizar jogo: $e');
    }
  }

  Future<void> subscribeToEvent(int? eventId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/eventos/inscrever-operador/$eventId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 201) {
        await fetchSubscribedGames();
      } else {
        debugPrint(
            'Erro ao inscrever no evento: ${response.statusCode} - ${response.body}');
        throw Exception('Erro ao inscrever no evento');
      }
    } catch (e) {
      debugPrint('Erro ao inscrever no evento: $e');
    }
  }

  Future<void> unsubscribeFromEvent(int? eventId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final response = await http.delete(
        Uri.parse('$_baseUrl/eventos/desinscrever-operador/$eventId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await fetchSubscribedGames();
      } else {
        throw Exception('Erro ao desinscrever do evento');
      }
    } catch (e) {
      debugPrint('Erro ao desinscrever do evento: $e');
    }
  }

  void searchGames(String query) {
    if (query.isEmpty) {
      _filteredGames = [];
    } else {
      _filteredGames = _games
          .where((game) =>
              game.descricao.toLowerCase().contains(query.toLowerCase()) ||
              game.cidade.toLowerCase().contains(query.toLowerCase()) ||
              game.nomeOrganizador!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void applyFilters({
    required String city,
    required String date,
    required bool isFree,
    required String period,
    required String modality,
  }) {
    _filteredGames = _games.where((game) {
      final matchCity = city.isEmpty ||
          game.cidade.toLowerCase().contains(city.toLowerCase());
      final matchDate = date.isEmpty ||
          DateFormat('dd/MM/yyyy').format(game.dataEvento) == date;
      final matchFree = !isFree || (game.valor == 0.0);
      final matchPeriod =
          period == 'Any' || game.periodo.toLowerCase() == period.toLowerCase();
      final matchModality = modality == 'Any' ||
          game.modalidadesJogos?.toLowerCase() == modality.toLowerCase();

      return matchCity &&
          matchDate &&
          matchFree &&
          matchPeriod &&
          matchModality;
    }).toList();

    notifyListeners();
  }

  Future<void> fetchGameHistory() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/eventos/historico-jogos'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _gameHistory = data
            .map((json) => Game.fromJson(json))
            .toList(); // Armazena na lista correta
        notifyListeners();
      } else {
        throw Exception('Erro ao buscar histórico de jogos');
      }
    } catch (e) {
      debugPrint('Erro ao buscar histórico de jogos: $e');
    }
  }
}
