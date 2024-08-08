import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../models/game.dart';

class PlayersDialog extends StatelessWidget {
  final Game game;

  const PlayersDialog({super.key, required this.game});

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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 650,
          maxHeight: 900,
        ),
        child: AlertDialog(
          backgroundColor: Colors.grey[850],
          title: const Column(
            children: [
              Text(
                'Jogadores Inscritos',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Nome',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Classe',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Contato',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 400,
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: game.players?.length ?? 1,
                  itemBuilder: (context, index) {
                    if (game.players == null || game.players!.isEmpty) {
                      return const ListTile(
                        title: Text(
                          'Nenhum jogador inscrito',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else {
                      final player = game.players![index];
                      // Pegando apenas o primeiro e segundo nome
                      final nomeSplit = player.nome.split(' ');
                      final nome = nomeSplit.length > 1
                          ? '${nomeSplit[0]} ${nomeSplit[1]}'
                          : player.nome;
                      return Container(
                        color:
                            index.isEven ? Colors.grey[800] : Colors.grey[700],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Text(
                                  nome,
                                  style: const TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                flex: 1,
                                child: Text(
                                  player.nomeClasse,
                                  style: const TextStyle(color: Colors.white70),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () => _launchWhatsApp(player.contato),
                                  child: Row(
                                    children: [
                                      Text(
                                        player.contato,
                                        style: const TextStyle(
                                            color: Colors.white70),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(width: 5),
                                      PhosphorIcon(
                                        PhosphorIcons.whatsappLogo(),
                                        size: 15,
                                        color: Colors.green,
                                        semanticLabel: 'whatsapp',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          actions: [
            const Center(
              child: Text(
                'Clique no número para falar o Operador com o pelo WhatsApp.',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  child: const Text(
                    'Fechar',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
