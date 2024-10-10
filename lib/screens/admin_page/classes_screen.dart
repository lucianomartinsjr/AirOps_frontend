import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/class.dart';
import '../../services/api/api_service.dart';
import 'components/base_edit_screen.dart';
import 'components/edit_item_screen.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  _ClassesScreenState createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  late Future<List<Class>> _classesFuture;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  void _loadClasses() {
    _classesFuture =
        Provider.of<ApiService>(context, listen: false).fetchClasses();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Class>>(
      future: _classesFuture,
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
            onAdd: () async {
              final result = await _navigateToEditScreen(
                context,
                'Adicionar Classe',
                (cls) async {
                  // Adicionar nova classe
                  return await Provider.of<ApiService>(context, listen: false)
                      .createClass(cls);
                },
              );
              if (result == true) {
                setState(() {
                  _loadClasses(); // Recarrega a lista de classes após adicionar
                });
              }
            },
            onEdit: (index) async {
              final result = await _navigateToEditScreen(
                context,
                'Editar Classe',
                (cls) async {
                  // Editar classe existente
                  return await Provider.of<ApiService>(context, listen: false)
                      .updateClass(cls);
                },
                initialClass: items[index],
              );
              if (result == true) {
                setState(() {
                  _loadClasses(); // Recarrega a lista de classes após edição
                });
              }
            },
          );
        }
      },
    );
  }

  Future<bool?> _navigateToEditScreen(
      BuildContext context, String title, Future<bool> Function(Class) onSave,
      {Class? initialClass}) {
    final nomeClasseController =
        TextEditingController(text: initialClass?.nomeClasse ?? '');
    final descricaoController =
        TextEditingController(text: initialClass?.descricao ?? '');
    bool ativo = initialClass?.ativo ?? true;

    return Navigator.of(context).push<bool>(MaterialPageRoute(
      builder: (context) => EditItemScreen(
        title: title,
        controllers: {
          'Nome da Classe': nomeClasseController,
          'Descrição': descricaoController,
        },
        isActive: ativo,
        onSave: () async {
          final newClass = Class(
            id: initialClass?.id,
            nomeClasse: nomeClasseController.text,
            descricao: descricaoController.text.isNotEmpty
                ? descricaoController.text
                : null,
            ativo: ativo,
            criadoEm: initialClass?.criadoEm,
          );
          final success = await onSave(newClass);
          if (success) {
            Navigator.of(context).pop(true);
          }
        },
        initialClass: initialClass,
      ),
    ));
  }
}
