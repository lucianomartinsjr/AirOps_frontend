import 'package:flutter/foundation.dart';
import '../models/game.dart';

class AirsoftService with ChangeNotifier {
  List<Game> _games = [];

  List<Game> get games => _games;

  void addGame(Game game) {
    _games.add(game);
    notifyListeners();
  }

  void fetchGames() {
    // Simulando a busca de dados de um backend
    _games = [
      Game(
          id: '1',
          name: 'Game 1',
          location: 'Location 1',
          date: DateTime.now()),
      Game(
          id: '2',
          name: 'Game 2',
          location: 'Location 2',
          date: DateTime.now().add(Duration(days: 1))),
    ];
    notifyListeners();
  }
}
