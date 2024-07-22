import 'package:flutter/material.dart';
import '../../../models/game.dart';
import 'package:intl/intl.dart';

class GameInfoGrid extends StatelessWidget {
  final Game game;

  const GameInfoGrid({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 3,
      padding: const EdgeInsets.all(8.0),
      children: [
        _buildInfoTile('Organizador', game.organizer),
        _buildInfoTile('Data do Evento', dateFormat.format(game.date)),
        _buildInfoTile('Modalidade', game.modality),
        _buildInfoTile('Período', game.period),
        _buildInfoTile(
            'Jogadores', '${game.playersRegistered} / ${game.maxPlayers}'),
        _buildInfoTile('Valor', 'R\$ ${game.fee.toStringAsFixed(2)}'),
      ],
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 14.0),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ],
    );
  }
}