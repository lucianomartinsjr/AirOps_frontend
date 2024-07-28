import 'package:flutter/material.dart';
import '../../../models/game.dart';

class GameDetailHeader extends StatelessWidget {
  final Game game;

  const GameDetailHeader({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(game.imagemCapa),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.black54,
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            game.titulo.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
