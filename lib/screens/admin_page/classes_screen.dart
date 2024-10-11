import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/class.dart';
import '../../services/api/api_service.dart';
import 'components/base_edit_screen.dart';
import 'components/edit_item_screen.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  ClassesScreenState createState() => ClassesScreenState();
}

class ClassesScreenState extends State<ClassesScreen> {
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
            items: items
                .map((cls) => {
                      'id': cls.id,
                      'descricao': cls.nomeClasse,
                      'ativo': cls.ativo, // Remova o '== true'
                      'detalhes': cls.descricao ?? '',
                    })
                .toList(),
            onAdd: () async {
              await _navigateToEditScreen(
                context,
                'Adicionar Classe',
                (cls) async {
                  try {
                    await Provider.of<ApiService>(context, listen: false)
                        .createClass(cls);
                    if (mounted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Classe criada com sucesso!')),
                          );
                        }
                      });
                    }
                    setState(() {
                      _loadClasses(); // Recarrega a lista de classes após adicionar
                    });
                    return true;
                  } catch (e) {
                    if (mounted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erro ao criar classe: $e')),
                          );
                        }
                      });
                    }
                    return false;
                  }
                },
              );
            },
            onEdit: (index) async {
              await _navigateToEditScreen(
                context,
                'Editar Classe',
                (cls) async {
                  try {
                    await Provider.of<ApiService>(context, listen: false)
                        .updateClass(cls);
                    if (mounted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Classe atualizada com sucesso!')),
                          );
                        }
                      });
                    }
                    setState(() {
                      _loadClasses(); // Recarrega a lista de classes após edição
                    });
                    return true;
                  } catch (e) {
                    if (mounted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Erro ao atualizar classe: $e')),
                          );
                        }
                      });
                    }
                    return false;
                  }
                },
                initialClass: items[index],
              );
            },
          );
        }
      },
    );
  }

  Future<void> _navigateToEditScreen(
      BuildContext context, String title, Future<bool> Function(Class) onSave,
      {Class? initialClass}) async {
    final nomeClasseController =
        TextEditingController(text: initialClass?.nomeClasse ?? '');
    final descricaoController =
        TextEditingController(text: initialClass?.descricao ?? '');
    bool ativo = initialClass?.ativo ?? true;

    final result = await Navigator.of(context).push<bool>(MaterialPageRoute(
      builder: (context) => EditItemScreen(
        title: title,
        controllers: {
          'Nome da Classe': nomeClasseController,
          'Descrição': descricaoController,
        },
        isActive: ativo,
        onSave: (bool isActive) async {
          final newClass = Class(
            id: initialClass?.id,
            nomeClasse: nomeClasseController.text,
            descricao: descricaoController.text.isNotEmpty
                ? descricaoController.text
                : null,
            ativo: isActive,
            criadoEm: initialClass?.criadoEm,
          );
          final success = await onSave(newClass);
          if (success) {
            if (context.mounted) {
              Navigator.of(context).pop(true);
            }
          }
        },
        initialClass: initialClass,
      ),
    ));

    if (result == true) {
      setState(() {
        _loadClasses(); // Recarrega a lista de classes após edição ou adição
      });
    }
  }
}
