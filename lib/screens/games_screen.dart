import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/airsoft_service.dart';
import '../widgets/game_list.dart';
import 'game/create_game_screen.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  _GamesScreenState createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AirsoftService>(context, listen: false)
          .fetchSubscribedGames();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMenuButton(
                  context,
                  icon: Icons.manage_search,
                  label: 'Gerenciar meus Jogos',
                  onTap: () {
                    // Navegar para a tela de gerenciamento de jogos
                  },
                ),
                _buildMenuButton(
                  context,
                  icon: Icons.add,
                  label: 'Registrar um novo Jogo',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateGameScreen(),
                    ));
                  },
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Inscrições',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18),
              ),
            ),
          ),
          Expanded(
            child: Consumer<AirsoftService>(
              builder: (context, airsoftService, child) {
                return GameList(games: airsoftService.subscribedGames);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
