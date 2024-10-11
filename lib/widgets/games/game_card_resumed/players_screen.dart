import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../models/game.dart';

class PlayersScreen extends StatefulWidget {
  final Game game;

  const PlayersScreen({super.key, required this.game});

  @override
  PlayersScreenState createState() => PlayersScreenState();
}

class PlayersScreenState extends State<PlayersScreen> {
  int? selectedPlayerIndex;

  String _cleanContact(String contato) {
    // Remove todos os caracteres que não são números
    return contato.replaceAll(RegExp(r'[^0-9]'), '');
  }

  void _launchWhatsApp(String contato) async {
    final cleanedContact = _cleanContact(contato);
    final Uri url = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: '/55$cleanedContact',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerCount = widget.game.players?.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogadores'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[900],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildHeader(playerCount),
              const SizedBox(height: 16),
              Expanded(
                child: _buildPlayersList(),
              ),
              if (selectedPlayerIndex != null)
                _buildPlayerDetails(widget.game.players![selectedPlayerIndex!]),
              _buildFooterHint(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(int playerCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Jogadores Inscritos',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$playerCount ${playerCount == 1 ? "jogador" : "jogadores"}',
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayersList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildColumnHeaders(),
          Expanded(
            child: ListView.separated(
              itemCount: widget.game.players?.length ?? 1,
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.grey[800], height: 1),
              itemBuilder: (context, index) {
                if (widget.game.players == null ||
                    widget.game.players!.isEmpty) {
                  return _buildEmptyState();
                } else {
                  final player = widget.game.players![index];
                  return _buildPlayerRow(player, index);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnHeaders() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildColumnHeader('Nome'),
          ),
          Expanded(
            flex: 2,
            child: _buildColumnHeader('Classe'),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  Widget _buildPlayerRow(dynamic player, int index) {
    final isSelected = selectedPlayerIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          selectedPlayerIndex = isSelected ? null : index;
        });
      },
      child: Container(
        color: isSelected ? Colors.red.withOpacity(0.2) : null,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 16,
                    child: Text(
                      player.nome[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      player.nome,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                player.nomeClasse,
                style: const TextStyle(color: Colors.white70),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Nenhum jogador inscrito',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  Widget _buildFooterHint() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Toque no jogador para ver detalhes',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white54,
              fontStyle: FontStyle.italic,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPlayerDetails(dynamic player) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detalhes do Jogador',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          _buildDetailRow('Nome Completo:', player.nome),
          _buildDetailRow('Classe:', player.nomeClasse),
          _buildDetailRow('Contato:', player.contato, isContact: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isContact = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(color: Colors.white70)),
          ),
          Expanded(
            flex: 3,
            child: isContact
                ? GestureDetector(
                    onTap: () => _launchWhatsApp(value),
                    child: Row(
                      children: [
                        Text(value,
                            style: const TextStyle(color: Colors.white)),
                        const SizedBox(width: 8),
                        Icon(
                          PhosphorIcons.whatsappLogo(),
                          size: 18,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  )
                : Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
