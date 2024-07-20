import 'package:flutter/material.dart';
import 'package:diacritic/diacritic.dart';

class BaseScreen extends StatefulWidget {
  final String title;
  final List<String> items;
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
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  String searchQuery = '';
  bool showInactive = false; // True for inactive, false for active

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filtrar itens com base na pesquisa e no estado ativo/inativo
    final filteredItems = widget.items.where((item) {
      final isActive =
          true; // Substitua com a lógica real para determinar se o item está ativo ou inativo
      final normalizedItem = removeDiacritics(item.toLowerCase());
      final normalizedQuery = removeDiacritics(searchQuery.toLowerCase());
      final matchesQuery = normalizedItem.contains(normalizedQuery);
      return matchesQuery && (showInactive != isActive);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style:
                theme.textTheme.headlineMedium?.copyWith(color: Colors.white)),
        backgroundColor: theme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Campo de pesquisa
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                hintText: 'Pesquisar...',
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            // Filtro ativo/inativo
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Mostrar inativos',
                  style: TextStyle(color: Colors.white),
                ),
                Switch(
                  value: showInactive,
                  onChanged: (value) {
                    setState(() {
                      showInactive = value;
                    });
                  },
                  activeColor: Colors.red,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[700],
                ),
              ],
            ),
            SizedBox(height: 10),
            // Lista de itens filtrados
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.grey[800],
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      title: Text(
                        filteredItems[index],
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: Colors.white),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit, color: Colors.grey[400]),
                        onPressed: () => widget.onEdit(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onAdd,
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }
}
