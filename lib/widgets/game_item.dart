import 'package:flutter/material.dart';
import '../models/game.dart';

class GameItem extends StatelessWidget {
  final Game game;

  GameItem({required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(game.name),
        subtitle: Text('${game.location} - ${game.date.toLocal()}'),
      ),
    );
  }
}
