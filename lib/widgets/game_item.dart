import 'package:flutter/material.dart';
import '../models/game.dart';

class GameItem extends StatelessWidget {
  final Game game;

  GameItem({required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        children: [
          Image.network(game.imageUrl, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.0),
                Text('Tipo campo: ${game.fieldType}',
                    style: TextStyle(color: Colors.white70)),
                Text('Modalidade: ${game.modality}',
                    style: TextStyle(color: Colors.white70)),
                Text('Período: ${game.period}',
                    style: TextStyle(color: Colors.white70)),
                Text('Local: ${game.location}',
                    style: TextStyle(color: Colors.white70)),
                Text('Organizador: ${game.organizer}',
                    style: TextStyle(color: Colors.white70)),
                Text('Data: ${game.date.toLocal()}',
                    style: TextStyle(color: Colors.white70)),
                Text('Taxa de campo: R\$${game.fee.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
