import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../models/game.dart';

class AirsoftService with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _baseUrl = 'http://localhost:3000';

  List<Game> _games = [];
  List<Game> _filteredGames = [];
  List<Game> _subscribedGames = [];
  List<Game> _organizerGames = [];

  List<Game> get games => _filteredGames.isNotEmpty ? _filteredGames : _games;
  List<Game> get subscribedGames => _subscribedGames;
  List<Game> get organizerGames => _organizerGames;

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  void addGame(Game game) {
    _games.add(game);
    notifyListeners();
  }

  Future<void> fetchGames() async {
    try {
      final response = await http.get(
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
        Uri.parse('$_baseUrl/subscribed-games'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _subscribedGames = data.map((json) => Game.fromJson(json)).toList();
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
        Uri.parse('$_baseUrl/eventos/organizador'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _organizerGames = data.map((json) => Game.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to fetch organizer games');
      }
    } catch (e) {
      debugPrint('Erro ao buscar jogos organizados: $e');
    }
  }

  Future<void> updateGame(String id, Game updatedGame) async {
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

  Future<void> subscribeToEvent(String eventId) async {
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

      if (response.statusCode == 200) {
        await fetchSubscribedGames();
      } else {
        throw Exception('Erro ao inscrever no evento');
      }
    } catch (e) {
      debugPrint('Erro ao inscrever no evento: $e');
    }
  }

  Future<void> unsubscribeFromEvent(String eventId) async {
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
        // Fetch subscribed games again to update the list
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
              game.name.toLowerCase().contains(query.toLowerCase()) ||
              game.location.toLowerCase().contains(query.toLowerCase()) ||
              game.organizer.toLowerCase().contains(query.toLowerCase()))
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
    required String fieldType,
  }) {
    _filteredGames = _games.where((game) {
      final matchCity = city.isEmpty ||
          game.location.toLowerCase().contains(city.toLowerCase());
      final matchDate =
          date.isEmpty || DateFormat('dd/MM/yyyy').format(game.date) == date;
      final matchFree = !isFree || game.fee == 0.0;
      final matchPeriod = period == 'Qualquer período' || game.period == period;
      final matchModality = modality == 'Any' || game.modality == modality;
      final matchFieldType = fieldType == 'Any' || game.fieldType == fieldType;

      return matchCity &&
          matchDate &&
          matchFree &&
          matchPeriod &&
          matchModality &&
          matchFieldType;
    }).toList();

    notifyListeners();
  }
}
