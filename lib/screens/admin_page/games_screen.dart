import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/game.dart';
import '../../services/api/api_service.dart';
import '../../widgets/games/game_card_resumed/players_dialog.dart';

class GamesAdminScreen extends StatefulWidget {
  const GamesAdminScreen({super.key});

  @override
  _GamesAdminScreenState createState() => _GamesAdminScreenState();
}

class _GamesAdminScreenState extends State<GamesAdminScreen> {
  List<Game> games = [];
  List<Game> filteredGames = [];
  bool showActiveOnly = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchGames();
  }

  Future<void> _fetchGames() async {
    try {
      final fetchedGames = await Provider.of<ApiService>(context, listen: false)
          .fetchAdminGames();
      setState(() {
        games = fetchedGames;
        _filterGames();
      });
    } catch (error) {
      // Handle error
    }
  }

  void _filterGames() {
    setState(() {
      filteredGames = games.where((game) {
        final matchesSearch =
            game.titulo.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesStatus = showActiveOnly ? game.ativo : true;
        return matchesSearch && matchesStatus!;
      }).toList();
    });
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Lógica para adicionar novo jogo
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Pesquisar',
                labelStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor:
                    Colors.grey[800], // Cor de fundo da barra de pesquisa
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  _filterGames();
                });
              },
            ),
          ),
          SwitchListTile(
            title: const Text('Mostrar apenas ativos',
                style: TextStyle(color: Colors.white)),
            value: showActiveOnly,
            onChanged: (value) {
              setState(() {
                showActiveOnly = value;
                _filterGames();
              });
            },
            activeColor: Colors.red,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredGames.length,
              itemBuilder: (context, index) {
                final game = filteredGames[index];
                return Card(
                  color: Colors.grey[850], // Cor de fundo do card
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text(
                      game.titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      'Data: ${_formatDate(game.dataEvento)}\nOperador: ${game.nomeOrganizador}\nModalidades: ${game.modalidadesJogos}\nJogadores: ${game.quantidadeJogadoresInscritos}/${game.numMaxOperadores}',
                      style: const TextStyle(
                        fontSize: 14.0,
                        height: 1.4,
                        color: Colors.white70,
                      ),
                    ),
                    trailing: IconButton(
                      icon:
                          const Icon(Icons.remove_red_eye, color: Colors.white),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => PlayersDialog(game: game),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
