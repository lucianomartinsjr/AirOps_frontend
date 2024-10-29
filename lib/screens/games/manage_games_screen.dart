import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game.dart';
import '../../services/api/airsoft_service.dart';
import '../../widgets/games/game_card_resumed/game_list_view.dart';
import 'create_game_screen.dart';

class ManageGamesScreen extends StatefulWidget {
  const ManageGamesScreen({super.key});

  @override
  ManageGamesScreenState createState() => ManageGamesScreenState();
}

class ManageGamesScreenState extends State<ManageGamesScreen> {
  bool _isLoading = true;
  String _searchQuery = '';
  String _filter = 'Agendados';

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
        backgroundColor: Colors.grey[850],
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
                      (_filter == 'Agendados' && (game.ativo ?? false)) ||
                      (_filter == 'Concluídos' &&
                          !(game.ativo ?? true) &&
                          (game.dataEvento.isAfter(DateTime(1900, 1, 1)))) ||
                      (_filter == 'Cancelados' &&
                          game.dataEvento
                              .isAtSameMomentAs(DateTime(1900, 1, 1)));
                  return matchesSearchQuery && matchesFilter;
                }).toList();

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Buscar jogos...',
                                prefixIcon: const Icon(Icons.search,
                                    color: Colors.white),
                                hintStyle:
                                    const TextStyle(color: Colors.white54),
                                filled: true,
                                fillColor: Colors.grey[700],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                              ),
                              style: const TextStyle(color: Colors.white),
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              value: _filter,
                              decoration: InputDecoration(
                                labelText: 'Filtrar',
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 54, 54, 54),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                              ),
                              dropdownColor: Colors.grey[800],
                              items: [
                                'Todos',
                                'Agendados',
                                'Concluídos',
                                'Cancelados'
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _filter = newValue!;
                                });
                              },
                              style: const TextStyle(color: Colors.white),
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
                          : GameListView(
                              games: organizerGames,
                              onCancelGame: (game) {
                                _showCancelGameDialog(
                                    context, game, airsoftService);
                              },
                            ),
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

  void _showCancelGameDialog(
      BuildContext context, Game game, AirsoftService airsoftService) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation as Animation<double>,
            curve: Curves.easeOutBack,
          ),
          child: AlertDialog(
            backgroundColor: Colors.grey[850],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text(
              'Cancelar Jogo',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tem certeza que deseja cancelar o jogo:',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    '"${game.titulo}"',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Esta ação não pode ser desfeita.',
                        style:
                            TextStyle(color: Colors.amber[300], fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child:
                    const Text('Não', style: TextStyle(color: Colors.white70)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 5,
                ),
                child: const Text('Sim, cancelar'),
                onPressed: () async {
                  try {
                    Game updatedGame = Game(
                      id: game.id,
                      dataEvento: DateTime(1900, 1, 1),
                      titulo: game.titulo,
                      cidade: game.cidade,
                      descricao: game.descricao,
                      valor: game.valor,
                      periodo: game.periodo,
                      linkCampo: game.linkCampo,
                      numMaxOperadores: game.numMaxOperadores,
                      idModalidadeJogo: game.idModalidadeJogo,
                      imagemCapa: game.imagemCapa,
                    );

                    Navigator.of(context).pop();

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: Colors.grey[850],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.red),
                                    strokeWidth: 3,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Cancelando jogo...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );

                    await airsoftService.updateGame(game.id!, updatedGame);
                    await airsoftService.fetchOrganizerGames();

                    if (mounted) {
                      Navigator.of(context).pop();
                      _showCancelConfirmation(context);
                    }
                  } catch (error) {
                    if (mounted) {
                      Navigator.of(context).pop();
                      _showErrorMessage(
                          context, 'Erro ao cancelar o jogo: $error');
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCancelConfirmation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Jogo cancelado com sucesso'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.12,
          left: 16,
          right: 16,
        ),
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.12,
          left: 16,
          right: 16,
        ),
      ),
    );
  }
}
