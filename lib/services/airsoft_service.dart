import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/game.dart';
import '../models/players.dart';

class AirsoftService with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _baseUrl = 'https://suaapi.com';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  List<Game> _games = [];
  List<Game> _filteredGames = [];
  List<Game> _subscribedGames = []; // Jogos em que o usuário está inscrito
  List<Game> _organizerGames = []; // Jogos organizados pelo usuário

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
    // final token = await _getToken();
    // if (token == null) {
    //   throw Exception('Token não encontrado');
    // }

    // Dados fictícios para teste
    _games = [
      Game(
        id: '1',
        name: 'JOGO TREINO ARENA BLACK SHEEP',
        location: 'Rio Verde - GO',
        date: DateTime.parse('2024-06-03 19:30:00'),
        fieldType: 'CQB',
        modality: 'ForFun',
        period: 'Noturno',
        organizer: 'BlackSheep',
        fee: 25.00,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/9/98/Airsoft_squad.jpg',
        details: """
⏰ Horário 08:00 chegada
08:30 início do game 🕥

⚠ Uso obrigatório ⚠
🥽 De óculos de proteção🕶
-Ataduras ou Torniquetes
-Faixas Azul 🔵 e Amarelo 🟡 

🛑 Honra
🛑 Honestidade
🛑 Respeito
        """,
        locationLink: "https://goo.gl/maps/tka7FxES8JoA44gy6",
      ),
      Game(
        id: '2',
        name: 'JOGO TREINO ARENA BLACK SHEEP',
        location: 'Rio Verde - GO',
        date: DateTime.parse('2024-10-03 23:30:00'),
        fieldType: 'CQB',
        modality: 'ForFun',
        period: 'Noturno',
        organizer: 'BlackSheep',
        fee: 0.00,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/9/98/Airsoft_squad.jpg',
        details: """
⏰ Horário 08:00 chegada
08:30 início do game 🕥

⚠ Uso obrigatório ⚠
🥽 De óculos de proteção🕶
-Ataduras ou Torniquetes
-Faixas Azul 🔵 e Amarelo 🟡 

🛑 Honra
🛑 Honestidade
🛑 Respeito
        """,
        locationLink: "https://goo.gl/maps/tka7FxES8JoA44gy6",
      ),
      Game(
        id: '3',
        name: 'Operação Unidade 731',
        location: 'Rio Verde - GO',
        date: DateTime.parse('2024-03-24 08:30:00'),
        fieldType: 'Outdoor',
        modality: 'Milsim',
        period: 'Vespertino',
        organizer: 'COC',
        fee: 75.20,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/9/98/Airsoft_squad.jpg',
        details: """
⏰ Horário 08:00 chegada
08:30 início do game 🕥

⚠ Uso obrigatório ⚠
🥽 De óculos de proteção🕶
-Ataduras ou Torniquetes
-Faixas Azul 🔵 e Amarelo 🟡 

🛑 Honra
🛑 Honestidade
🛑 Respeito
        """,
        locationLink: "https://goo.gl/maps/tka7FxES8JoA44gy6",
      ),
    ];
    _filteredGames = [];
    notifyListeners();
  }

  Future<void> fetchSubscribedGames() async {
    // final token = await _getToken();
    // if (token == null) {
    //   throw Exception('Token não encontrado');
    // }

    // Dados fictícios para teste
    _subscribedGames = [
      Game(
        id: '1',
        name: 'JOGO TREINO ARENA BLACK SHEEP',
        location: 'Rio Verde - GO',
        date: DateTime.parse('2024-06-03 19:30:00'),
        fieldType: 'CQB',
        modality: 'ForFun',
        period: 'Noturno',
        organizer: 'BlackSheep',
        fee: 25.00,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/9/98/Airsoft_squad.jpg',
        details: """
⏰ Horário 08:00 chegada
08:30 início do game 🕥

⚠ Uso obrigatório ⚠
🥽 De óculos de proteção🕶
-Ataduras ou Torniquetes
-Faixas Azul 🔵 e Amarelo 🟡 

🛑 Honra
🛑 Honestidade
🛑 Respeito
        """,
        locationLink: "https://goo.gl/maps/tka7FxES8JoA44gy6",
      ),
      // Outros jogos inscritos podem ser adicionados aqui
    ];
    notifyListeners();
  }

  Future<void> fetchOrganizerGames() async {
    // Dados fictícios para teste
    _organizerGames = [
      Game(
        id: '1',
        name: 'JOGO TREINO ARENA BLACK SHEEP',
        location: 'Rio Verde - GO',
        date: DateTime.parse('2024-06-03 19:30:00'),
        fieldType: 'CQB',
        modality: 'ForFun',
        period: 'Noturno',
        organizer: 'BlackSheep',
        fee: 25.00,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/9/98/Airsoft_squad.jpg',
        details: "",
        locationLink: "https://goo.gl/maps/tka7FxES8JoA44gy6",
        players: [
          Player(name: 'Ana Silva', role: 'Apoio'),
          Player(name: 'Bruno Costa', role: 'Explorador'),
          Player(name: 'Carlos Oliveira', role: 'Sniper'),
          Player(name: 'Daniela Souza', role: 'Assalto'),
          Player(name: 'Eduardo Lima', role: 'Médico'),
          Player(name: 'Fernanda Santos', role: 'Engenheiro'),
          Player(name: 'Gabriel Ferreira', role: 'Apoio'),
          Player(name: 'Heloísa Rodrigues', role: 'Explorador'),
          Player(name: 'Igor Almeida', role: 'Sniper'),
          Player(name: 'Juliana Barbosa', role: 'Assalto'),
          Player(name: 'Leonardo Pereira', role: 'Médico'),
          Player(name: 'Mariana Carvalho', role: 'Engenheiro'),
          Player(name: 'Nicolas Moreira', role: 'Apoio'),
          Player(name: 'Olivia Martins', role: 'Explorador'),
          Player(name: 'Pedro Rocha', role: 'Sniper'),
          Player(name: 'Quênia Dias', role: 'Assalto'),
          Player(name: 'Rafael Batista', role: 'Médico'),
          Player(name: 'Sofia Teixeira', role: 'Engenheiro'),
          Player(name: 'Tiago Gomes', role: 'Apoio'),
          Player(name: 'Úrsula Ribeiro', role: 'Explorador'),
          Player(name: 'Vicente Cunha', role: 'Sniper'),
          Player(name: 'Wesley Cardoso', role: 'Assalto'),
          Player(name: 'Ximena Braga', role: 'Médico'),
          Player(name: 'Yuri Nascimento', role: 'Engenheiro'),
          Player(name: 'Zélia Franco', role: 'Apoio')
        ],
      ),
      // Outros jogos organizados podem ser adicionados aqui
    ];
    notifyListeners();
  }

  Future<void> updateGame(String id, Game updatedGame) async {
    final token = await _secureStorage.read(key: 'tokenjwt');
    final url = '$_baseUrl/games/$id';

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(updatedGame.toJson()),
    );

    if (response.statusCode == 200) {
      // Atualize a lista de jogos localmente ou notifique os listeners
      notifyListeners();
    } else {
      throw Exception('Failed to update game');
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
}
