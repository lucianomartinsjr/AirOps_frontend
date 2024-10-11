import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importe o pacote intl para formatação de data
import '../../../models/game.dart';
import '../../../screens/games/game_detail/game_detail_screen.dart';

class GameItem extends StatelessWidget {
  final Game game;

  const GameItem({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: () => _navigateToGameDetail(context),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 12.0), // Adiciona espaço à esquerda da imagem
              child: _buildImage(),
            ),
            const SizedBox(
                width: 12), // Mantém o espaço entre a imagem e o conteúdo
            Expanded(child: _buildContent(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return SizedBox(
      width: 120, // Aumentamos o tamanho da imagem
      height: 120, // Aumentamos o tamanho da imagem
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(8), // Arredonda todos os cantos da imagem
        child: Image.asset(
          'assets/images/airops-cover.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
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
          const SizedBox(height: 4),
          _buildInfoRow(
              Icons.sports_soccer, game.modalidadesJogos ?? 'Não especificado',
              isBold: true),
          const SizedBox(height: 4),
          _buildInfoRow(Icons.access_time, game.periodo),
          const SizedBox(height: 4),
          _buildInfoRow(Icons.location_on, game.cidade),
          const SizedBox(height: 8),
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
        Icon(icon, size: 16, color: Colors.red[300]),
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
        TextButton(
          onPressed: () => _navigateToGameDetail(context),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[300],
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Ver Detalhes',
            style: TextStyle(fontSize: 12, color: Colors.grey[300]),
          ),
        ),
        Text(
          game.valor == 0.0
              ? 'GRATUITO'
              : 'R\$${game.valor.toStringAsFixed(2)}',
          style: TextStyle(
            color: game.valor == 0.0 ? Colors.green[300] : Colors.red[300],
            fontWeight: FontWeight.bold,
            fontSize: 16,
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
}
