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
  GameDetailScreenState createState() => GameDetailScreenState();
}

class GameDetailScreenState extends State<GameDetailScreen> {
  bool isError = false;
  bool isSuccess = false;
  bool isSubscribed = false;
  String errorMessage = '';
  bool _isExpanded = true;
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
      if (!mounted) return;
      setState(() {
        isSuccess = true;
        isSubscribed = true;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inscrição realizada com sucesso!')),
      );
    } catch (e) {
      if (!mounted) return;
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
      if (!mounted) return;
      setState(() {
        isSuccess = true;
        isSubscribed = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Desinscrição realizada com sucesso!')),
      );
    } catch (e) {
      if (!mounted) return;
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
      if (!mounted) return;
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocorreu um erro')),
      );
    }
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
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
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GameDetailHeader(game: widget.game),
                      const SizedBox(height: 16.0),
                      _buildInfoCard(
                        child: GameInfoGrid(game: widget.game),
                      ),
                      const SizedBox(height: 16.0),
                      _buildDescriptionCard(),
                      const SizedBox(height: 180.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GameDetailButtons(
              isError: isError,
              isSuccess: isSuccess,
              errorMessage: errorMessage,
              onMapTap: _openMap,
              onInscreverTap: isSubscribed ? desinscrever : inscrever,
              isSubscribed: isSubscribed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required Widget child}) {
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: InkWell(
        onTap: _toggleExpanded,
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Informações sobre o evento',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              AnimatedCrossFade(
                firstChild: Text(
                  widget.game.descricao,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 16.0, height: 1.5),
                ),
                secondChild: Text(
                  widget.game.descricao,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 16.0, height: 1.5),
                ),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
                sizeCurve: Curves.easeInOut,
              ),
              if (_isExpanded)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Toque para recolher',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6), fontSize: 14.0),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
