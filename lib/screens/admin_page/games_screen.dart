import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/game.dart';
import '../../services/api/api_service.dart';
import '../../widgets/games/game_card_resumed/players_screen.dart'; // Atualize este import

class GamesAdminScreen extends StatefulWidget {
  const GamesAdminScreen({super.key});

  @override
  GamesAdminScreenState createState() => GamesAdminScreenState();
}

class GamesAdminScreenState extends State<GamesAdminScreen> {
  List<Game> games = [];
  List<Game> filteredGames = [];
  String selectedFilter = 'Todos';
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
        final matchesStatus = (selectedFilter == 'Todos') ||
            (selectedFilter == 'Ativos' && game.ativo!) ||
            (selectedFilter == 'Inativos' && !game.ativo!);
        return matchesSearch && matchesStatus;
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
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Pesquisar',
                      labelStyle: const TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.white70),
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
                const SizedBox(width: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color:
                        Colors.grey[900], // Cor de fundo um pouco mais escura
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey[800]!),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedFilter,
                      items: ['Todos', 'Ativos', 'Inativos']
                          .map((filter) => DropdownMenuItem(
                                value: filter,
                                child: Text(filter),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedFilter = value!;
                          _filterGames();
                        });
                      },
                      dropdownColor: Colors.grey[900],
                      style: const TextStyle(color: Colors.white),
                      iconEnabledColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PlayersScreen(game: game),
                          ),
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
