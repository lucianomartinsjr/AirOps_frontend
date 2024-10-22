import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importe o pacote intl para formatação de data
import 'package:url_launcher/url_launcher.dart';
import '../../../models/game.dart';
import '../../../screens/games/game_detail/game_detail_screen.dart';

class GameItemSmall extends StatelessWidget {
  final Game game;

  const GameItemSmall({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: InkWell(
        onTap: () => _navigateToGameDetail(context),
        borderRadius: BorderRadius.circular(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildImage(),
            ),
            Expanded(child: _buildContent(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        'assets/images/airops-cover.jpg',
        width: 90,
        height: 90,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            game.titulo,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          _buildDateTimeRow(),
          _buildInfoRow(
              Icons.sports_soccer, game.modalidadesJogos ?? 'Não especificado'),
          _buildInfoRow(Icons.location_on, game.cidade),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: _buildLocationButton(context),
          ),
          const SizedBox(height: 4),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildDateTimeRow() {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final formattedDateTime = dateFormat.format(game.dataEvento);
    return _buildInfoRow(
      Icons.calendar_today,
      formattedDateTime,
      isBold: true,
      textColor: Colors.white,
    );
  }

  Widget _buildInfoRow(IconData icon, String text,
      {bool isBold = false, Color? textColor}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.red[300]),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.grey[300],
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Visualizar detalhes',
          style: TextStyle(
              fontSize: 12, color: Color.fromARGB(255, 104, 104, 104)),
        ),
        Text(
          game.valor == 0.0
              ? 'GRATUITO'
              : 'R\$${game.valor.toStringAsFixed(2)}',
          style: TextStyle(
            color: game.valor == 0.0 ? Colors.green[300] : Colors.red[300],
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  void _navigateToGameDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GameDetailScreen(game: game, token: ''),
      ),
    );
  }

  Widget _buildLocationButton(BuildContext context) {
    return Tooltip(
      message: 'Abrir localização no maps',
      child: InkWell(
        onTap: () {
          if (game.linkCampo.isNotEmpty) {
            launchUrl(Uri.parse(game.linkCampo));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Link do campo não disponível')),
            );
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ver localização no maps',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.map, color: Colors.red[300], size: 20),
          ],
        ),
      ),
    );
  }
}
