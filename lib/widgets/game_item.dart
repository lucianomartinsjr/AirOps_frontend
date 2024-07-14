import 'package:flutter/material.dart';
import '../models/game.dart';
import '../screens/game/game_detail/game_detail_screen.dart';

class GameItem extends StatelessWidget {
  final Game game;

  const GameItem({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GameDetailScreen(
              game: game,
              token: '',
            ),
          ),
        );
      },
      child: Card(
        color: Colors.grey[850],
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(game.imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Tipo campo: ${game.fieldType}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      'Modalidade: ${game.modality}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      'Período: ${game.period}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      'Local: ${game.location}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      'Organizador: ${game.organizer}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      'Data: ${game.date.toLocal().day}/${game.date.toLocal().month}/${game.date.toLocal().year}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      'Hora: ${game.date.toLocal().hour}:${game.date.toLocal().minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      'Taxa de campo: R\$${game.fee.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
