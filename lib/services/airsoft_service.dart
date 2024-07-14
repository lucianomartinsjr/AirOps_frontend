import 'package:flutter/foundation.dart';
import '../models/game.dart';

class AirsoftService with ChangeNotifier {
  List<Game> _games = [];
  List<Game> _filteredGames = [];

  List<Game> get games => _filteredGames.isNotEmpty ? _filteredGames : _games;

  void addGame(Game game) {
    _games.add(game);
    notifyListeners();
  }

  void fetchGames() {
    // Simulando a busca de dados de um backend
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
