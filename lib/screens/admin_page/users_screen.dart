import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/api_service.dart';
import 'components/base_edit_screen.dart';
import 'components/edit_item_screen.dart';

class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: Provider.of<ApiService>(context, listen: false).fetchUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar dados'));
        } else {
          return BaseScreen(
            title: 'Usuários',
            items: snapshot.data ?? [],
            onAdd: () {
              _navigateToEditScreen(context, 'Adicionar Usuário', (value) {
                // Adicionar novo usuário
              });
            },
            onEdit: (index) {
              _navigateToEditScreen(context, 'Editar Usuário', (value) {
                // Editar usuário existente
              }, initialValue: snapshot.data![index]);
            },
          );
        }
      },
    );
  }

  void _navigateToEditScreen(
      BuildContext context, String title, ValueChanged<String> onSave,
      {String? initialValue}) {
    final controller = TextEditingController(text: initialValue);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditItemScreen(
        title: title,
        controllers: {'Usuário': controller},
        onSave: () {
          onSave(controller.text);
          Navigator.of(context).pop();
        },
      ),
    ));
  }
}
