import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/modality.dart';
import '../../services/api/api_service.dart';
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
          final items = snapshot.data ?? [];
          return BaseScreen(
            title: 'Modalidades',
            items: items.map((modality) => modality.descricao).toList(),
            onAdd: () {
              _navigateToEditScreen(
                context,
                'Adicionar Modalidade',
                (modality) {
                  // Adicionar nova modalidade
                },
              );
            },
            onEdit: (index) {
              _navigateToEditScreen(
                context,
                'Editar Modalidade',
                (modality) {
                  // Editar modalidade existente
                },
                initialModality: items[index],
              );
            },
          );
        }
      },
    );
  }

  void _navigateToEditScreen(
      BuildContext context, String title, ValueChanged<Modality> onSave,
      {Modality? initialModality}) {
    final descricaoController =
        TextEditingController(text: initialModality?.descricao ?? '');
    final rulesController =
        TextEditingController(text: initialModality?.regras ?? '');
    final creationDateController =
        TextEditingController(text: initialModality?.criadoEM.toString() ?? '');
    bool isActive = initialModality?.ativo ?? true;

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditItemScreen(
        title: title,
        controllers: {
          'Descrição': descricaoController,
          'Regras': rulesController,
        },
        isActive: isActive,
        onSave: () {
          onSave(Modality(
            id: initialModality?.id ?? 0,
            descricao: descricaoController.text,
            regras: rulesController.text,
            criadoEM: DateTime.parse(creationDateController.text),
            ativo: isActive,
          ));
          Navigator.of(context).pop();
        },
        initialModality: initialModality,
      ),
    ));
  }
}
