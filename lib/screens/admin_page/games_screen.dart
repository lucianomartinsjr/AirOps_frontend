import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import 'components/base_edit_screen.dart';

class GamesAdminScreen extends StatelessWidget {
  const GamesAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: Provider.of<ApiService>(context, listen: false)
          .fetchGames(), // Implementar fetchGames no ApiService
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar dados'));
        } else {
          return BaseScreen(
            title: 'Jogos',
            items: snapshot.data ?? [],
            onAdd: () {
              // Lógica para adicionar novo jogo
            },
            onEdit: (index) {
              // Lógica para editar o jogo no índice fornecido
            },
          );
        }
      },
    );
  }
}
