import 'package:flutter/material.dart';
import '../../../models/game.dart';
import 'game_item_small.dart';
import 'game_item.dart';

class GameList extends StatelessWidget {
  final List<Game> games;
  final bool isLargeView;

  const GameList({
    super.key,
    required this.games,
    this.isLargeView = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: isLargeView
              ? GameItem(game: games[index])
              : GameItemSmall(game: games[index]),
        );
      },
    );
  }
}
