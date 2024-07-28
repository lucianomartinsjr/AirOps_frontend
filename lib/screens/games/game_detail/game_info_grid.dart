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
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2,
      padding: const EdgeInsets.all(8.0),
      children: [
        _buildInfoTile('Organizador', game.nomeOrganizador ?? 'N/A'),
        _buildInfoTile('Modalidade', game.modalidadesJogos ?? 'N/A'),
        _buildInfoTile('Data do Evento', dateFormat.format(game.dataEvento)),
        _buildInfoTile('Período', game.periodo),
        _buildInfoTile('Jogadores',
            '${game.quantidadeJogadoresInscritos ?? 0} / ${game.numMaxOperadores}'),
        _buildInfoTile(
          'Valor',
          game.valor == 0.00
              ? 'Não há'
              : 'R\$ ${game.valor.toStringAsFixed(2)}',
        ),
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
          style: const TextStyle(color: Colors.white70, fontSize: 12.0),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 14.0),
        ),
      ],
    );
  }
}
