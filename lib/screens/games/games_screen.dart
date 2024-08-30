import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game.dart';
import '../../services/api/airsoft_service.dart';
import '../../widgets/games/game_item_detailed/game_list.dart';
import 'create_game_screen.dart';
import 'history_game_screen.dart';
import 'manage_games_screen.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  _GamesScreenState createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> with RouteAware {
  String _searchQuery = '';
  String? _selectedDate;
  String? _selectedModality;
  String? _selectedLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AirsoftService>(context, listen: false)
          .fetchSubscribedGames();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Registrar a página para monitorar eventos de navegação
    RouteObserver<ModalRoute>().subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    // Recarregar os jogos inscritos ao retornar para a página
    Provider.of<AirsoftService>(context, listen: false).fetchSubscribedGames();
  }

  @override
  void dispose() {
    // Cancelar a inscrição no RouteObserver
    RouteObserver<ModalRoute>().unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<AirsoftService>(
        builder: (context, airsoftService, child) {
          final games = airsoftService.subscribedGames;

          // Opções dinâmicas para os filtros, formatando a data
          final dateOptions = games
              .map((game) => _formatDate(game.dataEvento))
              .toSet()
              .toList();
          final modalityOptions = games
              .map((game) => game.modalidadesJogos ?? '')
              .where((modality) => modality.isNotEmpty)
              .toSet()
              .toList();
          final locationOptions = games
              .map((game) => game.cidade ?? '')
              .where((location) => location.isNotEmpty)
              .toSet()
              .toList();

          final filteredGames = _applyFilters(games);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMenuButton(
                      context,
                      icon: Icons.history,
                      label: 'Histórico de Participação',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const HistoryScreen(),
                        ));
                      },
                    ),
                    _buildMenuButton(
                      context,
                      icon: Icons.manage_search,
                      label: 'Gerenciar\n Meus Jogos',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ManageGamesScreen(),
                        ));
                      },
                    ),
                    _buildMenuButton(
                      context,
                      icon: Icons.add,
                      label: 'Registrar \nNovo Jogo',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const CreateGameScreen(),
                        ));
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildSearchField(),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownRow(
                            context,
                            dateOptions,
                            modalityOptions,
                            locationOptions,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white),
                          onPressed: _clearFilters,
                          tooltip: 'Limpar Filtros',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Jogos Inscritos',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filteredGames.isEmpty
                    ? _buildNoResults()
                    : GameList(games: filteredGames),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.white),
        hintText: 'Pesquisar ...',
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.grey[800],
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
      onChanged: (value) {
        setState(() {
          _searchQuery =
              value.toLowerCase(); // Corrige para permitir a busca por nome
        });
      },
    );
  }

  Widget _buildDropdownRow(
    BuildContext context,
    List<String> dateOptions,
    List<String> modalityOptions,
    List<String> locationOptions,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildDropdown(
            context,
            value: _selectedDate,
            hint: 'Data',
            items: dateOptions,
            onChanged: (value) {
              setState(() {
                _selectedDate = value;
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildDropdown(
            context,
            value: _selectedModality,
            hint: 'Modalidade',
            items: modalityOptions,
            onChanged: (value) {
              setState(() {
                _selectedModality = value;
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildDropdown(
            context,
            value: _selectedLocation,
            hint: 'Localidade',
            items: locationOptions,
            onChanged: (value) {
              setState(() {
                _selectedLocation = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(BuildContext context,
      {String? value,
      required String hint,
      required List<String> items,
      required void Function(String?) onChanged}) {
    return SizedBox(
      height: 35,
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(
          hint,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[800],
          contentPadding: const EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 8.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        ),
        dropdownColor: Colors.grey[800],
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
        iconEnabledColor: Colors.white,
        iconSize: 16,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                item,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
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
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 105, 105, 105).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Nenhum resultado encontrado.',
              style: TextStyle(
                color: Color.fromARGB(255, 138, 138, 138),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: _clearFilters,
              child: const Text(
                'Limpar Filtros',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 0, 0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Game> _applyFilters(List<Game> games) {
    return games.where((game) {
      final matchesSearchQuery =
          game.titulo.toLowerCase().contains(_searchQuery);
      final matchesDate = _selectedDate == null ||
          _formatDate(game.dataEvento) == _selectedDate;
      final matchesModality = _selectedModality == null ||
          game.modalidadesJogos == _selectedModality;
      final matchesLocation =
          _selectedLocation == null || game.cidade == _selectedLocation;

      return matchesSearchQuery &&
          matchesDate &&
          matchesModality &&
          matchesLocation;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedDate = null;
      _selectedModality = null;
      _selectedLocation = null;
    });
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}
