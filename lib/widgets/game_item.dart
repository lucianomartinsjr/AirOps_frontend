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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 120,
                    height: 120,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 73, 73, 73),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn('Organizador', game.organizer),
                  _buildInfoColumn(
                      'Taxa de campo', 'R\$${game.fee.toStringAsFixed(2)}'),
                  _buildDateColumn(
                      '${game.date.toLocal().day.toString().padLeft(2, '0')}/${game.date.toLocal().month.toString().padLeft(2, '0')}/${game.date.toLocal().year} \n${game.date.toLocal().hour.toString().padLeft(2, '0')}:${game.date.toLocal().minute.toString().padLeft(2, '0')}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDateColumn(String value) {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
