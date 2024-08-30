import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api/airsoft_service.dart';
import '../../widgets/games/game_card_resumed/game_list_view.dart';
import 'create_game_screen.dart';

class ManageGamesScreen extends StatefulWidget {
  const ManageGamesScreen({super.key});

  @override
  _ManageGamesScreenState createState() => _ManageGamesScreenState();
}

class _ManageGamesScreenState extends State<ManageGamesScreen> {
  bool _isLoading = true;
  String _searchQuery = '';
  String _filter = 'Ativos'; // Define "Ativos" como padrão

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AirsoftService>(context, listen: false)
          .fetchOrganizerGames()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro ao carregar jogos: $error'),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus jogos"),
        backgroundColor: Colors.grey[850], // Cinza escuro para o AppBar
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<AirsoftService>(
              builder: (context, airsoftService, child) {
                final organizerGames =
                    airsoftService.organizerGames.where((game) {
                  final matchesSearchQuery = game.titulo
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase());
                  final matchesFilter = _filter == 'Todos' ||
                      (_filter == 'Ativos' && (game.ativo ?? false)) ||
                      (_filter == 'Inativos' && !(game.ativo ?? true));
                  return matchesSearchQuery && matchesFilter;
                }).toList();

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Buscar jogos...',
                                prefixIcon:
                                    Icon(Icons.search, color: Colors.white),
                                hintStyle: TextStyle(color: Colors.white54),
                                filled: true,
                                fillColor: Colors.grey[700],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              value: _filter,
                              decoration: InputDecoration(
                                labelText: 'Filtrar',
                                labelStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 54, 54, 54),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              dropdownColor: Colors.grey[800],
                              items: ['Todos', 'Ativos', 'Inativos']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _filter = newValue!;
                                });
                              },
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: organizerGames.isEmpty
                          ? const Center(
                              child: Text(
                                'Nenhum jogo encontrado',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : GameListView(games: organizerGames),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const CreateGameScreen(),
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Registrar novo jogo',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Retornar',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white70),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
