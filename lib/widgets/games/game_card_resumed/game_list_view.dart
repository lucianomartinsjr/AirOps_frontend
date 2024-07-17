import 'package:flutter/material.dart';
import '../../../models/game.dart';
import 'game_card.dart';

class GameListView extends StatelessWidget {
  final List<Game> games;

  const GameListView({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (context, index) {
        return GameCard(game: games[index]);
      },
    );
  }
}
