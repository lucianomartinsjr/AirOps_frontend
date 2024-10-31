import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/game.dart';
import 'package:intl/intl.dart';
import '../../../services/api/airsoft_service.dart';
import 'game_detail_header.dart';
import 'game_info_grid.dart';
import 'game_detail_buttons.dart';
import 'package:provider/provider.dart';

class GameDetailScreen extends StatefulWidget {
  final Game game;
  final String token;
  final Function(int gameId, bool isSubscribed)? onSubscriptionChanged;

  const GameDetailScreen({
    super.key,
    required this.game,
    required this.token,
    this.onSubscriptionChanged,
  });

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
  late ScaffoldMessengerState _scaffoldMessenger;

  @override
  void initState() {
    super.initState();
    isSubscribed = widget.game.inscrito!;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  @override
  void didUpdateWidget(GameDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.game.inscrito != widget.game.inscrito) {
      setState(() {
        isSubscribed = widget.game.inscrito!;
      });
    }
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

      Provider.of<AirsoftService>(context, listen: false)
          .updateGameSubscriptionStatus(widget.game.id!, true);

      widget.onSubscriptionChanged?.call(widget.game.id!, true);
      if (!mounted) return;
      _scaffoldMessenger.showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12.0),
              Text('Inscrição realizada com sucesso!'),
            ],
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.14,
            left: 16,
            right: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
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

      Provider.of<AirsoftService>(context, listen: false)
          .updateGameSubscriptionStatus(widget.game.id!, false);

      widget.onSubscriptionChanged?.call(widget.game.id!, false);
      if (!mounted) return;
      _scaffoldMessenger.showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12.0),
              Text('Desinscrição realizada com sucesso!'),
            ],
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.14,
            left: 16,
            right: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
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
      _scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o Google Maps')),
      );
    }
  }

  void _shareViaWhatsApp() async {
    final descricao = widget.game.descricao.replaceAll(RegExp(r'[*_~]'), '');
    final organizador =
        widget.game.nomeOrganizador?.replaceAll(RegExp(r'[*_~]'), '') ??
            'Não informado';
    final cidade =
        widget.game.cidade?.replaceAll(RegExp(r'[*_~]'), '') ?? 'Não informado';
    final valor = widget.game.valor?.toStringAsFixed(2) ?? '0.00';

    String dataFormatada = 'Data não informada';
    String horaFormatada = 'Hora não informada';
    try {
      dataFormatada = DateFormat('dd/MM/yyyy').format(widget.game.dataEvento);
      horaFormatada = DateFormat('HH:mm').format(widget.game.dataEvento);
    } catch (e) {
      debugPrint('Erro ao formatar data: $e');
    }

    final text = '''
🎮 *NOVO JOGO DE AIRSOFT!*

🏟️ *Evento:* $descricao
👥 *Organizador:* $organizador
📅 *Data:* $dataFormatada
⏰ *Horário:* $horaFormatada
📍 *Local:* $cidade
💰 *Taxa:* R\$ $valor
👥 *Vagas:* ${widget.game.quantidadeJogadoresInscritos ?? 0}/${widget.game.numMaxOperadores ?? 0}

ℹ️ *Detalhes do Evento:* 
$descricao

📱 *Baixe o AirOps para participar:*
https://play.google.com/store/apps/details?id=com.fasoft.airops
''';

    try {
      final maxLength = 4000;
      final messageToShare =
          text.length > maxLength ? '${text.substring(0, maxLength)}...' : text;

      final encodedText =
          Uri.encodeComponent(messageToShare).replaceAll('+', '%20');

      final whatsappUrlApp = Uri.parse('whatsapp://send?text=$encodedText');
      final whatsappUrlWeb = Uri.parse('https://wa.me/?text=$encodedText');

      bool launched = false;

      if (await canLaunchUrl(whatsappUrlApp)) {
        launched = await launchUrl(
          whatsappUrlApp,
          mode: LaunchMode.externalNonBrowserApplication,
        );
      }

      if (!launched && await canLaunchUrl(whatsappUrlWeb)) {
        launched = await launchUrl(
          whatsappUrlWeb,
          mode: LaunchMode.externalApplication,
        );
      }

      if (!launched && mounted) {
        _showErrorSnackBar(
            'Não foi possível abrir o WhatsApp. Verifique se o aplicativo está instalado.');
      }
    } catch (e) {
      debugPrint('Erro ao compartilhar: $e');
      if (!mounted) return;
      _showErrorSnackBar('Ocorreu um erro ao tentar compartilhar');
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

  void _showErrorSnackBar(String message) {
    _scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _scaffoldMessenger.clearSnackBars();
    super.dispose();
  }
}
