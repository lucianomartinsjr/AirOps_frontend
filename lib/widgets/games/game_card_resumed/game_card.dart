import 'package:flutter/material.dart';
import '../../../models/game.dart';
import 'players_dialog.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          // Parte superior com informações do jogo e ícone de edição
          Container(
            decoration: const BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          game.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                '${game.date.day.toString().padLeft(2, '0')}/${game.date.month.toString().padLeft(2, '0')}/${game.date.year} \n    ${game.date.hour.toString().padLeft(2, '0')}:${game.date.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Text(
                                'Período:\n${game.period}',
                                style: const TextStyle(color: Colors.white70),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white70),
                    onPressed: () {
                      // Ação ao clicar no ícone de edição
                    },
                  ),
                ],
              ),
            ),
          ),
          // Parte inferior com informações dos participantes e ícone de olho
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${game.playersRegistered} Participante(s) inscrito(s)',
                      style: const TextStyle(color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.visibility, color: Colors.white70),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return PlayersDialog(game: game);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
