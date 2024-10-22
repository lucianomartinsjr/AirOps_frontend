import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/game.dart';
import '../../../screens/games/edit_game_screen.dart';
import 'players_screen.dart';
import '../../../screens/games/create_game_screen.dart';

class GameCard extends StatelessWidget {
  final Game game;
  final Function(Game) onCancelGame;

  const GameCard({
    super.key,
    required this.game,
    required this.onCancelGame,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCancelled = game.dataEvento.year == 1900 &&
        game.dataEvento.month == 1 &&
        game.dataEvento.day == 1;

    return Card(
      elevation: 4,
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: isCancelled ? null : () => _showParticipants(context),
        borderRadius: BorderRadius.circular(16.0),
        child: Column(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
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
                  IconButton(
                    icon: const Icon(Icons.copy_all, color: Colors.blueAccent),
                    onPressed: () => _createNewGameBasedOnThis(context),
                    tooltip: 'Clonar Evento',
                  ),
                  IconButton(
                    icon: Icon(Icons.edit,
                        color: Colors.green
                            .withOpacity(game.ativo == true ? 1.0 : 0.2)),
                    onPressed:
                        game.ativo == true ? () => _editGame(context) : null,
                    tooltip: 'Editar',
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel_rounded,
                        color: Colors.red
                            .withOpacity(game.ativo == true ? 1.0 : 0.2)),
                    onPressed:
                        game.ativo == true ? () => onCancelGame(game) : null,
                    tooltip: 'Cancelar',
                  ),
                ],
              ),
            ),
            // Conteúdo
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(Icons.event, _formatDateTime(game.dataEvento)),
                  const SizedBox(height: 8.0),
                  _buildInfoRow(Icons.schedule, 'Período: ${game.periodo}'),
                  const SizedBox(height: 16.0),
                  _buildPlayerCountIndicator(),
                  const SizedBox(height: 16.0),
                  if (!isCancelled) _buildViewPlayersIndicator(),
                ],
              ),
            ),
          ],
        ),
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

  Widget _buildPlayerCountIndicator() {
    final currentPlayers = game.quantidadeJogadoresInscritos ?? 0;
    final maxPlayers = game.numMaxOperadores;
    final progress = currentPlayers / maxPlayers!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Jogadores: $currentPlayers/$maxPlayers',
              style: const TextStyle(color: Colors.white70, fontSize: 14.0),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                color: progress >= 0.9 ? Colors.red : Colors.white70,
                fontWeight:
                    progress >= 0.9 ? FontWeight.bold : FontWeight.normal,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[700],
          valueColor: AlwaysStoppedAnimation<Color>(
            progress >= 0.9 ? Colors.red : const Color.fromARGB(255, 233, 0, 0),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    if (dateTime.year == 1900 && dateTime.month == 1 && dateTime.day == 1) {
      return 'JOGO CANCELADO';
    }
    final adjustedDateTime = dateTime.subtract(const Duration(hours: 3));
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    return dateFormat.format(adjustedDateTime);
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

  void _createNewGameBasedOnThis(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateGameScreen(baseGame: game),
      ),
    );
  }

  Widget _buildViewPlayersIndicator() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.people, color: Colors.white70, size: 18.0),
        SizedBox(width: 8.0),
        Text(
          'Toque para ver os jogadores inscritos',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14.0,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
