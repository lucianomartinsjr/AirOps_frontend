import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/modality.dart';
import '../../services/api/api_service.dart';
import 'components/base_edit_screen.dart';
import 'components/edit_item_screen.dart';

class ModalitiesScreen extends StatefulWidget {
  @override
  _ModalitiesScreenState createState() => _ModalitiesScreenState();
}

class _ModalitiesScreenState extends State<ModalitiesScreen> {
  late Future<List<Modality>> _modalitiesFuture;

  @override
  void initState() {
    super.initState();
    _loadModalities();
  }

  void _loadModalities() {
    _modalitiesFuture =
        Provider.of<ApiService>(context, listen: false).fetchModalities();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Modality>>(
      future: _modalitiesFuture,
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
                (modality) async {
                  try {
                    await Provider.of<ApiService>(context, listen: false)
                        .createModality(modality);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Modalidade criada com sucesso!')),
                    );
                    setState(() {
                      _loadModalities(); // Recarrega as modalidades
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao criar modalidade: $e')),
                    );
                  }
                },
              );
            },
            onEdit: (index) {
              _navigateToEditScreen(
                context,
                'Editar Modalidade',
                (modality) async {
                  try {
                    final updatedModality = modality.copyWith(
                      id: items[index].id,
                      criadoEM: items[index].criadoEM,
                    );
                    await Provider.of<ApiService>(context, listen: false)
                        .updateModality(updatedModality);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Modalidade atualizada com sucesso!')),
                    );
                    setState(() {
                      _loadModalities(); // Recarrega as modalidades
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Erro ao atualizar modalidade: $e')),
                    );
                  }
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
    BuildContext context,
    String title,
    ValueChanged<Modality> onSave, {
    Modality? initialModality,
  }) {
    final descricaoController =
        TextEditingController(text: initialModality?.descricao ?? '');
    final rulesController =
        TextEditingController(text: initialModality?.regras ?? '');
    // Inicializa o valor de isActive corretamente
    bool isActive =
        initialModality?.ativo ?? false; // Altere para false como padrão

    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => EditItemScreen(
        title: title,
        controllers: {
          'Descrição': descricaoController,
          'Regras': rulesController,
        },
        isActive: isActive,
        onSave: () {
          final modality = Modality(
            id: initialModality?.id,
            descricao: descricaoController.text,
            regras: rulesController.text,
            criadoEM: initialModality?.criadoEM,
            ativo: isActive,
          );

          onSave(modality);
          Navigator.of(context).pop();
        },
        initialModality: initialModality,
      ),
    ))
        .then((_) {
      setState(() {
        _loadModalities();
      });
    });
  }
}
