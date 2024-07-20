import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/modality.dart';
import '../../services/api_service.dart';
import 'components/base_edit_screen.dart';
import 'components/edit_item_screen.dart';

class ModalitiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Modality>>(
      future: Provider.of<ApiService>(context, listen: false).fetchModalities(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar dados'));
        } else {
          final items =
              snapshot.data?.map((modality) => modality.name).toList() ?? [];
          return BaseScreen(
            title: 'Modalidades',
            items: items,
            onAdd: () {
              _navigateToEditScreen(context, 'Adicionar Modalidade', (value) {
                // Adicionar nova modalidade
              });
            },
            onEdit: (index) {
              _navigateToEditScreen(context, 'Editar Modalidade', (value) {
                // Editar modalidade existente
              }, initialValue: items[index]);
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
        controllers: {'Modalidade': controller},
        onSave: () {
          onSave(controller.text);
          Navigator.of(context).pop();
        },
      ),
    ));
  }
}
