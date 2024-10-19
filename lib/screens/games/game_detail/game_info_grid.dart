import 'package:flutter/material.dart';
import '../../../models/game.dart';
import 'package:intl/intl.dart';

class GameInfoGrid extends StatelessWidget {
  final Game game;

  const GameInfoGrid({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: _buildInfoChip('Data',
                    dateFormat.format(game.dataEvento), Icons.calendar_today)),
            const SizedBox(width: 8),
            Expanded(
                child: _buildInfoChip('Período', game.periodo, Icons.timer)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child: _buildInfoChip('Modalidade',
                    game.modalidadesJogos ?? 'N/A', Icons.sports)),
            const SizedBox(width: 8),
            Expanded(
              child: _buildInfoChip(
                'Jogadores',
                '${game.quantidadeJogadoresInscritos ?? 0}/${game.numMaxOperadores}',
                Icons.group,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child: _buildInfoChip('Organizador',
                    game.nomeOrganizador ?? 'N/A', Icons.person)),
            const SizedBox(width: 8),
            Expanded(
              child: _buildInfoChip(
                'Taxa',
                game.valor == 0.00
                    ? 'Gratuito'
                    : 'R\$ ${game.valor.toStringAsFixed(2)}',
                Icons.attach_money,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
