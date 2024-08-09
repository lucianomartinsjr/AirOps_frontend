import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/game.dart';
import 'package:intl/intl.dart';
import '../../../services/api/airsoft_service.dart';
import 'game_detail_header.dart';
import 'game_info_grid.dart';
import 'game_detail_buttons.dart';

class GameDetailScreen extends StatefulWidget {
  final Game game;
  final String token;

  const GameDetailScreen({super.key, required this.game, required this.token});

  @override
  _GameDetailScreenState createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  bool isError = false;
  bool isSuccess = false;
  bool isSubscribed = false;
  String errorMessage = '';
  bool _isExpanded = false;
  final ScrollController _scrollController = ScrollController();
  final AirsoftService _airsoftService = AirsoftService();

  @override
  void initState() {
    super.initState();
    isSubscribed = widget.game.inscrito!;
  }

  Future<void> inscrever() async {
    setState(() {
      isError = false;
      isSuccess = false;
      errorMessage = '';
    });

    try {
      await _airsoftService.subscribeToEvent(widget.game.id);
      setState(() {
        isSuccess = true;
        isSubscribed = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inscrição realizada com sucesso!')),
      );
    } catch (e) {
      setState(() {
        isError = true;
        errorMessage = 'Erro ao realizar inscrição. Tente novamente.';
      });
    }
  }

  Future<void> desinscrever() async {
    setState(() {
      isError = false;
      isSuccess = false;
      errorMessage = '';
    });

    try {
      await _airsoftService.unsubscribeFromEvent(widget.game.id);
      setState(() {
        isSuccess = true;
        isSubscribed = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Desinscrição realizada com sucesso!')),
      );
    } catch (e) {
      setState(() {
        isError = true;
        errorMessage = 'Erro ao realizar desinscrição. Tente novamente.';
      });
    }
  }

  Future<void> _openMap() async {
    final googleMapsUrl = Uri.parse(widget.game.linkCampo);

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o Google Maps')),
      );
    }
  }

  void _shareViaWhatsApp() async {
    final text = '''
🏟️ *Evento:* ${widget.game.descricao}
👥 *Organizador:* ${widget.game.nomeOrganizador}
📅 *Data:* ${DateFormat('dd/MM/yyyy').format(widget.game.dataEvento)}
📍 *Local:* ${widget.game.cidade}

ℹ️ *Detalhes:* 
  ${widget.game.descricao}

Para se inscrever e saber mais detalhes, instale o aplicativo *AirOps*. 
''';

    final whatsappUrl = Uri(
      scheme: 'https',
      host: 'api.whatsapp.com',
      path: 'send',
      queryParameters: {'text': text},
    );

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocorreu um erro')),
      );
    }
  }

  void _scrollToDetails() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Detalhes do Evento"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareViaWhatsApp,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GameDetailHeader(game: widget.game),
                  const SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: GameInfoGrid(game: widget.game),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Center(
                    child: Text(
                      '- Descrição - ',
                      style: TextStyle(color: Colors.white70, fontSize: 12.0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                      if (!_isExpanded) {
                        _scrollToDetails();
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8.0),
                          AnimatedCrossFade(
                            firstChild: Text(
                              widget.game.descricao,
                              maxLines: 2,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                            secondChild: Text(
                              widget.game.descricao,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                            crossFadeState: _isExpanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 300),
                          ),
                          const SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
          GameDetailButtons(
            isError: isError,
            isSuccess: isSuccess,
            errorMessage: errorMessage,
            onMapTap: _openMap,
            onInscreverTap: isSubscribed ? desinscrever : inscrever,
            isSubscribed: isSubscribed,
          ),
        ],
      ),
    );
  }
}
