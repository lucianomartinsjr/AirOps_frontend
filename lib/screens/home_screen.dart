import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/airsoft_service.dart';
import '../widgets/game_list.dart';
import 'create_game_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airsoft Games'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreateGameScreen(),
              ));
            },
          ),
        ],
      ),
      body: Consumer<AirsoftService>(
        builder: (context, airsoftService, child) {
          return GameList(games: airsoftService.games);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<AirsoftService>(context, listen: false).fetchGames();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
