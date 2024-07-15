import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/airsoft_service.dart';
import '../widgets/game_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AirsoftService>(context, listen: false).fetchGames();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Air Ops'),
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
    );
  }
}
