import 'package:airops_frontend/screens/profile_page/change_password.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api/airsoft_service.dart';
import '../widgets/form_fields/filter_dialog.dart';
import '../widgets/games/game_item_detailed/game_list.dart';
import 'admin_page/admin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool _isFree = false;
  String _selectedPeriod = 'Any';
  String _selectedModality = 'Any';
  bool _isAdmin = false;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AirsoftService>(context, listen: false).fetchGames();
      _checkIfAdmin();
      _checkPasswordChange();
    });
  }

  Future<void> _checkIfAdmin() async {
    String? isAdmin = await _secureStorage.read(key: 'isAdmin');
    setState(() {
      _isAdmin = isAdmin == 'true';
    });
  }

  Future<void> _checkPasswordChange() async {
    String? hasToChangePassword =
        await _secureStorage.read(key: 'hasToChangePassword');

    if (hasToChangePassword == 'true') {
      _showPasswordChangeAlert();
    }
  }

  void _showPasswordChangeAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 29, 29, 29),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Alterar Senha',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_outline,
                size: 64,
                color: Colors.white70,
              ),
              SizedBox(height: 16),
              Text(
                'Sua senha foi recuperada recentemente. Por segurança, recomendamos que você a altere agora.',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Deixar para depois',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 159, 0, 0),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Alterar agora',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _openAdminScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AdminScreen(),
    ));
  }

  void _openFilterDialog() {
    final List<String> modalityOptions =
        Provider.of<AirsoftService>(context, listen: false)
            .games
            .map((game) => game.modalidadesJogos)
            .where((modality) => modality != null)
            .cast<String>()
            .toSet()
            .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterDialog(
          cityController: _cityController,
          dateController: _dateController,
          isFree: _isFree,
          selectedPeriod: _selectedPeriod,
          selectedModality: _selectedModality,
          onApplyFilters: (city, date, isFree, period, modality) {
            setState(() {
              _isFree = isFree;
              _selectedPeriod = period;
              _selectedModality = modality;
            });
            Provider.of<AirsoftService>(context, listen: false).applyFilters(
              city: city,
              date: date,
              isFree: isFree,
              period: period,
              modality: modality,
            );
          },
          modalityOptions: modalityOptions,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Air Ops',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (_isAdmin)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _openAdminScreen,
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.primaryColor, theme.scaffoldBackgroundColor],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Pesquisar jogos',
                              hintStyle: TextStyle(color: Colors.white70),
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.white70),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                            ),
                            style: const TextStyle(color: Colors.white),
                            onChanged: (value) {
                              Provider.of<AirsoftService>(context,
                                      listen: false)
                                  .searchGames(value);
                              setState(() {}); // Adicione esta linha
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ClipOval(
                      child: Material(
                        color: Colors.white.withOpacity(0.1),
                        child: InkWell(
                          onTap: _openFilterDialog,
                          child: const Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.filter_list, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Consumer<AirsoftService>(
                  builder: (context, airsoftService, child) {
                    if (airsoftService.games.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event, size: 100, color: Colors.white38),
                            SizedBox(height: 20),
                            Text(
                              'Nenhum jogo disponível no momento.',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Tente ajustar os filtros ou volte mais tarde.',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white54),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return GameList(games: airsoftService.games);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
