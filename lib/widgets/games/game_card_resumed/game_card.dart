import 'package:flutter/material.dart';
import '../../../models/game.dart';
import '../../../screens/games/edit_game_screen.dart';
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
          // Header
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(135, 48, 48, 48),
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
                        Row(
                          children: [
                            const Icon(Icons.sports_esports,
                                color: Colors.white, size: 20.0),
                            const SizedBox(width: 8.0),
                            Text(
                              game.titulo,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Icon(Icons.event,
                                color: Colors.white70, size: 16.0),
                            const SizedBox(width: 8.0),
                            Text(
                              '${game.dataEvento.toLocal().day.toString().padLeft(2, '0')}/${game.dataEvento.toLocal().month.toString().padLeft(2, '0')}/${game.dataEvento.toLocal().year} '
                              '${game.dataEvento.toLocal().hour.toString().padLeft(2, '0')}:${game.dataEvento.toLocal().minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14.0,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Icon(Icons.schedule,
                                color: Colors.white70, size: 16.0),
                            const SizedBox(width: 8.0),
                            Text(
                              'Período: ${game.periodo}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14.0,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white70),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditGameScreen(game: game),
                        ),
                      );
                    },
                    tooltip: 'Editar jogo',
                  ),
                ],
              ),
            ),
          ),
          // Footer
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
                  Row(
                    children: [
                      const Icon(Icons.group,
                          color: Colors.white70, size: 16.0),
                      const SizedBox(width: 8.0),
                      Text(
                        '${game.quantidadeJogadoresInscritos} Participante(s) inscrito(s)',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14.0,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ],
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
                    tooltip: 'Ver participantes',
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
