import 'package:flutter/material.dart';
import '../../../models/game.dart';
import 'game_card.dart';

class GameListView extends StatelessWidget {
  final List<Game> games;
  final Function(Game) onCancelGame;

  const GameListView({
    super.key,
    required this.games,
    required this.onCancelGame,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return GameCard(
          game: game,
          onCancelGame: onCancelGame,
        );
      },
    );
  }
}
