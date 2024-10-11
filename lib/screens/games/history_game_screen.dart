import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../services/api/airsoft_service.dart';
import '../../models/game.dart'; // Adicione esta linha para importar o modelo Game

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  bool _isLoading = true;
  String _searchQuery = '';
  int _gameCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AirsoftService>(context, listen: false)
          .fetchGameHistory()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro ao carregar histórico: $error'),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Histórico de Jogos"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<AirsoftService>(
              builder: (context, airsoftService, child) {
                final gameHistory = airsoftService.gameHistory
                    .where((game) =>
                        game.ativo == true &&
                        game.titulo
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()))
                    .toList();

                _gameCount = gameHistory.length;

                return Column(
                  children: [
                    _buildSearchBar(),
                    _buildGameCount(),
                    Expanded(
                      child: gameHistory.isEmpty
                          ? _buildEmptyState()
                          : _buildGameList(gameHistory),
                    ),
                    _buildReturnButton(),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Pesquisar jogos...',
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: const Icon(Icons.search, color: Colors.white54),
          filled: true,
          fillColor: Colors.grey[850],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildGameCount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        'Jogos participados: $_gameCount',
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sports_esports, size: 80, color: Colors.grey[600]),
          const SizedBox(height: 16),
          Text(
            'Nenhum jogo encontrado',
            style: TextStyle(color: Colors.grey[400], fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGameList(List<Game> gameHistory) {
    return ListView.builder(
      itemCount: gameHistory.length,
      itemBuilder: (context, index) {
        final game = gameHistory[index];
        return _buildGameCard(game);
      },
    );
  }

  Widget _buildGameCard(Game game) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          game.titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            _buildInfoRow(Icons.calendar_today,
                'Data: ${DateFormat('dd/MM/yyyy HH:mm').format(game.dataEvento.toLocal())}'),
            _buildInfoRow(
                Icons.category, 'Modalidade: ${game.modalidadesJogos}'),
            _buildInfoRow(Icons.person, 'Organizador: ${game.nomeOrganizador}'),
          ],
        ),
        onTap: () {
          // Adicione aqui a navegação para os detalhes do jogo
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 14.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReturnButton() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Retornar',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
