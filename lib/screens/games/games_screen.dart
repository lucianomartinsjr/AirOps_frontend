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
  GamesScreenState createState() => GamesScreenState();
}

class GamesScreenState extends State<GamesScreen> with RouteAware {
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
    RouteObserver<ModalRoute>().subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    _reloadGames();
  }

  void _reloadGames() {
    Provider.of<AirsoftService>(context, listen: false).fetchSubscribedGames();
  }

  @override
  void dispose() {
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
              .map((game) => game.cidade)
              .where((location) => location.isNotEmpty)
              .toSet()
              .toList();

          final filteredGames = _applyFilters(games);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final buttonWidth = (constraints.maxWidth - 32) / 3;
                    return Row(
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
                          width: buttonWidth,
                        ),
                        _buildMenuButton(
                          context,
                          icon: Icons.manage_search,
                          label: 'Gerenciar\n Meus Jogos',
                          onTap: () async {
                            final result = await Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) => const ManageGamesScreen(),
                            ));
                            if (result == true) {
                              _reloadGames();
                            }
                          },
                          width: buttonWidth,
                        ),
                        _buildMenuButton(
                          context,
                          icon: Icons.add,
                          label: 'Registrar \nNovo Jogo',
                          onTap: () async {
                            final result = await Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) => const CreateGameScreen(),
                            ));
                            if (result == true) {
                              _reloadGames();
                            }
                          },
                          width: buttonWidth,
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSearchField(),
                    const SizedBox(height: 12),
                    _buildFilterRow(
                      context,
                      dateOptions,
                      modalityOptions,
                      locationOptions,
                    ),
                    const SizedBox(height: 8),
                    if (_isAnyFilterActive()) _buildClearFiltersButton(),
                  ],
                ),
              ),
              Expanded(
                child: filteredGames.isEmpty
                    ? _buildNoResults(games.isEmpty)
                    : GameList(games: filteredGames, isLargeView: false),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap,
      required double width}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
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
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.white70),
        hintText: 'Pesquisar jogos...',
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.grey[800],
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
      onChanged: (value) {
        setState(() {
          _searchQuery = value.toLowerCase();
        });
      },
    );
  }

  Widget _buildFilterRow(
    BuildContext context,
    List<String> dateOptions,
    List<String> modalityOptions,
    List<String> locationOptions,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(
            label: 'Data',
            options: dateOptions,
            selectedValue: _selectedDate,
            onSelected: (value) => setState(() => _selectedDate = value),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Modalidade',
            options: modalityOptions,
            selectedValue: _selectedModality,
            onSelected: (value) => setState(() => _selectedModality = value),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Localidade',
            options: locationOptions,
            selectedValue: _selectedLocation,
            onSelected: (value) => setState(() => _selectedLocation = value),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required List<String> options,
    required String? selectedValue,
    required Function(String?) onSelected,
  }) {
    return ChoiceChip(
      label: Text(
        selectedValue ?? label,
        style: TextStyle(
          color: selectedValue != null ? Colors.white : Colors.grey[400],
        ),
      ),
      selected: selectedValue != null,
      onSelected: (bool selected) {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              color: Colors.grey[900],
              child: ListView(
                children: options.map((option) {
                  return ListTile(
                    title: Text(option,
                        style: const TextStyle(color: Colors.white)),
                    onTap: () {
                      onSelected(option);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            );
          },
        );
      },
      backgroundColor: Colors.grey[800],
      selectedColor: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selectedValue != null ? Colors.red : Colors.grey[700]!,
          width: 1,
        ),
      ),
    );
  }

  Widget _buildNoResults(bool noSubscribedGames) {
    if (noSubscribedGames && !_isAnyFilterActive()) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 80,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum jogo inscrito',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Você ainda não está participando de nenhum evento.',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Nenhum resultado encontrado',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tente ajustar seus filtros para encontrar mais eventos.',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.filter_alt_off),
              label: const Text('Limpar Filtros'),
              onPressed: _clearFilters,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Game> _applyFilters(List<Game> games) {
    List<Game> filteredGames = games.where((game) {
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

    // Ordenar os jogos por data
    filteredGames.sort((a, b) => a.dataEvento.compareTo(b.dataEvento));

    return filteredGames;
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

  Widget _buildClearFiltersButton() {
    return Center(
      child: TextButton(
        onPressed: _clearFilters,
        child: const Text(
          'Limpar Filtros',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  bool _isAnyFilterActive() {
    return _searchQuery.isNotEmpty ||
        _selectedDate != null ||
        _selectedModality != null ||
        _selectedLocation != null;
  }
}
