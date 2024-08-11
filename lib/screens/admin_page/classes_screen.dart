import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/class.dart';
import '../../services/api/api_service.dart';
import 'components/base_edit_screen.dart';
import 'components/edit_item_screen.dart';

class ClassesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Class>>(
      future: Provider.of<ApiService>(context, listen: false).fetchClasses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar dados'));
        } else {
          final items = snapshot.data ?? [];
          return BaseScreen(
            title: 'Classes',
            items: items.map((cls) => cls.nomeClasse).toList(),
            onAdd: () {
              _navigateToEditScreen(
                context,
                'Adicionar Classe',
                (cls) {
                  // Adicionar nova classe
                },
              );
            },
            onEdit: (index) {
              _navigateToEditScreen(
                context,
                'Editar Classe',
                (cls) {
                  // Editar classe existente
                },
                initialClass: items[index],
              );
            },
          );
        }
      },
    );
  }

  void _navigateToEditScreen(
      BuildContext context, String title, ValueChanged<Class> onSave,
      {Class? initialClass}) {
    final nomeClasseController =
        TextEditingController(text: initialClass?.nomeClasse ?? '');
    final descricaoController =
        TextEditingController(text: initialClass?.descricao ?? '');
    final criadoEmController = TextEditingController(
        text: initialClass?.criadoEm?.toIso8601String() ?? '');
    bool ativo = initialClass?.ativo ?? true;

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditItemScreen(
        title: title,
        controllers: {
          'Nome da Classe': nomeClasseController,
          'Descrição': descricaoController,
        },
        isActive: ativo,
        onSave: () {
          onSave(Class(
            id: initialClass?.id ?? 0,
            nomeClasse: nomeClasseController.text,
            descricao: descricaoController.text,
            ativo: ativo,
            criadoEm: DateTime.tryParse(criadoEmController.text),
          ));
          Navigator.of(context).pop();
        },
        initialClass: initialClass,
      ),
    ));
  }
}
