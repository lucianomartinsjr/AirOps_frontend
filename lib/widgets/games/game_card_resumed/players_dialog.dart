import 'package:flutter/material.dart';
import '../../../models/game.dart';

class PlayersDialog extends StatelessWidget {
  final Game game;

  const PlayersDialog({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 900,
        ),
        child: AlertDialog(
          backgroundColor: Colors.grey[850],
          title: Column(
            children: [
              const Text(
                'Jogadores Inscritos',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              Text(
                'Total: ${game.players?.length ?? 0}',
                style: const TextStyle(color: Colors.white70, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nome',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Classe',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 400,
                  width: double.maxFinite,
                  child: ListView.builder(
                    itemCount: game.players?.length ?? 1,
                    itemBuilder: (context, index) {
                      if (game.players == null || game.players!.isEmpty) {
                        return const ListTile(
                          title: Text(
                            'Nenhum jogador inscrito',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        final player = game.players![index];
                        return Container(
                          color: index.isEven
                              ? Colors.grey[800]
                              : Colors.grey[700],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  player.name,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  player.role,
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    'Fechar',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
