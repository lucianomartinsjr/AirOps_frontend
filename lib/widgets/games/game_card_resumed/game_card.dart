import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/game.dart';
import '../../../screens/games/edit_game_screen.dart';
import 'players_screen.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cabeçalho
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16.0),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  game.titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              // Conteúdo
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                        Icons.event, _formatDateTime(game.dataEvento)),
                    const SizedBox(height: 12.0),
                    _buildInfoRow(Icons.schedule, 'Período: ${game.periodo}'),
                    const SizedBox(height: 12.0),
                    _buildInfoRow(Icons.group,
                        '${game.quantidadeJogadoresInscritos} Participante(s)'),
                    const SizedBox(height: 24.0),
                    Center(
                      child: _buildActionButton(
                        context,
                        icon: Icons.visibility,
                        label: 'Visualizar Participantes Inscritos',
                        onPressed: () => _showParticipants(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 8.0,
            right: 8.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () => _editGame(context),
                tooltip: 'Editar',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20.0),
        const SizedBox(width: 12.0),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 16.0),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    return dateFormat.format(dateTime);
  }

  void _editGame(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditGameScreen(game: game),
      ),
    );
  }

  void _showParticipants(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlayersScreen(game: game),
      ),
    );
  }
}
