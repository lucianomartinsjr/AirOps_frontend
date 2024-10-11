import 'package:flutter/material.dart';
import 'package:diacritic/diacritic.dart';

class BaseScreen extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>>
      items; // Alterado para List<Map<String, dynamic>>
  final VoidCallback onAdd;
  final ValueChanged<int> onEdit;

  const BaseScreen({
    super.key,
    required this.title,
    required this.items,
    required this.onAdd,
    required this.onEdit,
  });

  @override
  BaseScreenState createState() => BaseScreenState();
}

class BaseScreenState extends State<BaseScreen> {
  String searchQuery = '';
  bool showInactive = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filtrar itens com base na pesquisa e no estado ativo/inativo
    final filteredItems = widget.items.where((item) {
      final isActive = item['ativo'] as bool? ??
          false; // Use false como valor padrão se ativo for null
      final normalizedItem =
          removeDiacritics((item['descricao'] as String? ?? '').toLowerCase());
      final normalizedQuery = removeDiacritics(searchQuery.toLowerCase());
      final matchesQuery = normalizedItem.contains(normalizedQuery);
      return matchesQuery && (showInactive ? !isActive : isActive);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style:
                theme.textTheme.headlineMedium?.copyWith(color: Colors.white)),
        backgroundColor: theme.primaryColor,
        elevation: 0, // Remove a sombra da AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.primaryColor, theme.scaffoldBackgroundColor],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Campo de pesquisa aprimorado
              Theme(
                data: Theme.of(context).copyWith(
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white70),
                      hintText: 'Pesquisar...',
                      hintStyle: TextStyle(color: Colors.white70),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Filtro ativo/inativo aprimorado
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filtrar por status:',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    ToggleButtons(
                      borderRadius: BorderRadius.circular(15),
                      selectedBorderColor: Colors.red,
                      selectedColor: Colors.white,
                      fillColor: Colors.red,
                      color: Colors.white70,
                      constraints:
                          const BoxConstraints(minHeight: 40, minWidth: 80),
                      isSelected: [!showInactive, showInactive],
                      onPressed: (index) {
                        setState(() {
                          showInactive = index == 1;
                        });
                      },
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Ativos'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Inativos'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Lista de itens filtrados aprimorada
              Expanded(
                child: ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    final isActive = item['ativo'] as bool? ?? false;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        title: Text(
                          item['descricao'] as String? ?? '',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(color: Colors.white),
                        ),
                        subtitle: Text(
                          isActive ? 'Ativo' : 'Inativo',
                          style: TextStyle(
                              color: isActive ? Colors.green : Colors.red),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white70),
                          onPressed: () =>
                              widget.onEdit(widget.items.indexOf(item)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onAdd,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar'),
      ),
    );
  }
}
