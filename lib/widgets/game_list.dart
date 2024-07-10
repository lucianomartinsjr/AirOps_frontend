import 'package:flutter/material.dart';
import '../models/game.dart';
import 'game_item.dart';

class GameList extends StatelessWidget {
  final List<Game> games;

  const GameList({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (ctx, i) => GameItem(game: games[i]),
    );
  }
}
