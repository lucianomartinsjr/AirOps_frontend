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
      ),
      body: RefreshIndicator(
        onRefresh: _fetchGames,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Pesquisar jogos',
                        hintStyle: const TextStyle(color: Colors.white54),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.white70),
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
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
                  const SizedBox(width: 16.0),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(30.0),
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
                          isExpanded: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredGames.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum jogo encontrado',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredGames.length,
                      itemBuilder: (context, index) {
                        final game = filteredGames[index];
                        return Card(
                          color: Colors.grey[850],
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PlayersScreen(game: game),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(15.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          game.titulo,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                          color: game.ativo!
                                              ? Colors.green
                                              : Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Text(
                                          game.ativo! ? 'Ativo' : 'Inativo',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Data: ${_formatDate(game.dataEvento)}',
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  Text(
                                    'Operador: ${game.nomeOrganizador}',
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  Text(
                                    'Modalidades: ${game.modalidadesJogos}',
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                  const SizedBox(height: 8.0),
                                  _buildPlayerCountIndicator(game),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerCountIndicator(Game game) {
    final currentPlayers = game.quantidadeJogadoresInscritos ?? 0;
    final maxPlayers = game.numMaxOperadores;
    final progress = currentPlayers / maxPlayers!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[700],
          valueColor: AlwaysStoppedAnimation<Color>(
            progress >= 0.9 ? Colors.red : const Color.fromARGB(255, 233, 0, 0),
          ),
        ),
        const SizedBox(height: 4.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Jogadores: $currentPlayers/$maxPlayers',
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                color: progress >= 0.9 ? Colors.red : Colors.white70,
                fontWeight:
                    progress >= 0.9 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
