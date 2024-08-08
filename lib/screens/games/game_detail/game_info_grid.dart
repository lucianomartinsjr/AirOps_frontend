import 'package:flutter/material.dart';
import '../../../models/game.dart';
import 'package:intl/intl.dart';

class GameInfoGrid extends StatelessWidget {
  final Game game;

  const GameInfoGrid({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          crossAxisCount: 3, // 3 colunas
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio:
              (constraints.maxWidth / 3) / 100, // Ajusta o aspecto dos filhos
          padding: const EdgeInsets.all(8.0),
          children: [
            _buildInfoTile('Organizador', game.nomeOrganizador ?? 'N/A'),
            _buildInfoTile('Modalidade', game.modalidadesJogos ?? 'N/A'),
            _buildInfoTile(
                'Data do Evento', dateFormat.format(game.dataEvento)),
            _buildInfoTile('Período', game.periodo),
            _buildInfoTile(
              'Jogadores',
              '${game.quantidadeJogadoresInscritos ?? 0} / ${game.numMaxOperadores}',
            ),
            _buildInfoTile(
              'Taxa',
              game.valor == 0.00
                  ? 'Gratuito'
                  : 'R\$ ${game.valor.toStringAsFixed(2)}',
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
