import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '/../../../models/game.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
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
  String errorMessage = '';

  Future<void> inscrever() async {
    setState(() {
      isError = false;
      isSuccess = false;
      errorMessage = '';
    });

    final response = await http.post(
      Uri.parse('https://api.example.com/inscricao'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: jsonEncode({'gameId': widget.game.id}),
    );

    if (response.statusCode == 200) {
      setState(() {
        isSuccess = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inscrição realizada com sucesso!')),
      );
    } else {
      setState(() {
        isError = true;
        errorMessage = 'Erro ao realizar inscrição. Tente novamente.';
      });
    }
  }

  Future<void> _openMap() async {
    final googleMapsUrl = Uri.parse(widget.game.locationLink);

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

  🏟️ *Evento:* ${widget.game.name}
  👥 *Organizador:* ${widget.game.organizer}
  📅 *Data:* ${DateFormat('dd/MM/yyyy').format(widget.game.date)}
  📍 *Local:* ${widget.game.locationLink}

  ℹ️ *Detalhes:* 
    ${widget.game.details}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Air Ops"),
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GameDetailHeader(game: widget.game),
                  const SizedBox(height: 16.0),
                  GameInfoGrid(game: widget.game),
                  const Text(
                    'Detalhes',
                    style: TextStyle(color: Colors.white70, fontSize: 18.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.game.details,
                    style: const TextStyle(color: Colors.white, fontSize: 16.0),
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
            onInscreverTap: inscrever,
          ),
        ],
      ),
    );
  }
}
