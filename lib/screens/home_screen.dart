import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/airsoft_service.dart';
import '../widgets/games/game_item_detailed/game_list.dart';
import 'admin_page/admin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAdmin = true; // Temporariamente definido como true para simulação

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AirsoftService>(context, listen: false).fetchGames();
    });
  }

  void _openAdminScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AdminScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Air Ops'),
          automaticallyImplyLeading:
              false, // Adicionado para remover o ícone de voltar
          actions: [
            if (_isAdmin)
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: _openAdminScreen,
              ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquisar',
                  prefixIcon: const Icon(Icons.search),
                  fillColor: Colors.white24,
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  Provider.of<AirsoftService>(context, listen: false)
                      .searchGames(value);
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Filtrar por:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Consumer<AirsoftService>(
                builder: (context, airsoftService, child) {
                  return GameList(games: airsoftService.games);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
