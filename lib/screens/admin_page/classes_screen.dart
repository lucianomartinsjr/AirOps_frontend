import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../models/class.dart';
import 'components/base_edit_screen.dart';
import 'components/edit_item_screen.dart';

class ClassesScreen extends StatelessWidget {
  const ClassesScreen({super.key});

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
          return BaseScreen(
            title: 'Classes Jogadores',
            items: snapshot.data
                    ?.map((classItem) => classItem.nomeClasse)
                    .toList() ??
                [],
            onAdd: () {
              _navigateToEditScreen(context, 'Adicionar Classe', (value) {});
            },
            onEdit: (index) {
              _navigateToEditScreen(context, 'Editar Classe', (value) {},
                  initialValue: snapshot.data![index].nomeClasse);
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
        controllers: {'Classe': controller},
        onSave: () {
          onSave(controller.text);
          Navigator.of(context).pop();
        },
      ),
    ));
  }
}