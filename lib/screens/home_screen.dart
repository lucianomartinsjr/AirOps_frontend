import 'package:airops_frontend/screens/profile_page/change_password.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/airsoft_service.dart';
import '../widgets/form_fields/filter_dialog.dart';
import '../widgets/games/game_item_detailed/game_list.dart';
import 'admin_page/admin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool _isFree = false;
  String _selectedPeriod = 'Any';
  String _selectedModality = 'Any';
  String _selectedFieldType = 'Any';
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
          title: const Text('Alerta', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Sua senha foi recuperada. Deseja alterar a senha agora?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Deixar para depois',
                  style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ));
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                      255, 159, 0, 0), // Altere esta cor conforme necessário
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: const Text('Alterar agora',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openAdminScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AdminScreen(),
    ));
  }

  void _openFilterDialog() {
    final List<String> cityOptions =
        Provider.of<AirsoftService>(context, listen: false)
            .games
            .map((game) => game.linkCampo)
            .toSet()
            .toList(); // Obter cidades únicas dos jogos disponíveis

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterDialog(
          cityController: _cityController,
          dateController: _dateController,
          isFree: _isFree,
          selectedPeriod: _selectedPeriod,
          selectedModality: _selectedModality,
          selectedFieldType: _selectedFieldType,
          onApplyFilters: (city, date, isFree, period, modality, fieldType) {
            setState(() {
              _isFree = isFree;
              _selectedPeriod = period;
              _selectedModality = modality;
              _selectedFieldType = fieldType;
            });
            Provider.of<AirsoftService>(context, listen: false).applyFilters(
              city: city,
              date: date,
              isFree: isFree,
              period: period,
              modality: modality,
            );
          },
          cityOptions: cityOptions,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Air Ops'),
        automaticallyImplyLeading: false,
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
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
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
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  onPressed: _openFilterDialog,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
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
