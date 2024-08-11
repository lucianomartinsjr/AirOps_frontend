import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/class.dart';
import '../../../models/modality.dart';
import '../../../services/api/api_service.dart';
import '../../../widgets/form_fields/custom_text_form_field.dart';

class EditItemScreen extends StatefulWidget {
  final String title;
  final Map<String, TextEditingController> controllers;
  final bool isActive;
  final Function(Modality modality)? onSaveModality;
  final Function(Class classItem)? onSaveClass;
  final Modality? initialModality;
  final Class? initialClass;

  const EditItemScreen({
    super.key,
    required this.title,
    required this.controllers,
    required this.isActive,
    this.onSaveModality,
    this.onSaveClass,
    this.initialModality,
    this.initialClass,
    required this.onSave,
  });

  final Function() onSave;

  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.isActive;
    debugPrint('Initial isActive in EditItemScreen: $isActive');
  }

  void _saveItem() {
    debugPrint('Saving isActive value: $isActive');

    if (widget.initialModality != null) {
      final modality = Modality(
        id: widget.initialModality?.id,
        descricao: widget.controllers['Descrição']!.text,
        regras: widget.controllers['Regras']!.text,
        ativo: isActive,
        criadoEM: widget.initialModality?.criadoEM,
      );
      debugPrint('Modality created with active: ${modality.ativo}');

      Provider.of<ApiService>(context, listen: false).updateModality(modality);
    }

    widget.onSave();
  }

  @override
  Widget build(BuildContext context) {
    final isModality = widget.initialModality != null;
    final id =
        isModality ? widget.initialModality?.id : widget.initialClass?.id;
    final criadoEm = isModality
        ? widget.initialModality?.criadoEM
        : widget.initialClass?.criadoEm;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveItem,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (id != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID: $id',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 129, 129, 129),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  if (criadoEm != null)
                    Text(
                      'Data de Criação: ${criadoEm.toLocal().toString().split(' ')[0]}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 129, 129, 129),
                      ),
                    ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ...widget.controllers.entries.map((entry) {
              final label = entry.key;
              final controller = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CustomTextFormField(
                  controller: controller,
                  labelText: label,
                  readOnly: false,
                  maxLines: label == 'Regras' || label == 'Descrição' ? 5 : 1,
                ),
              );
            }).toList(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Ativo', style: TextStyle(fontSize: 16)),
                  Switch(
                    value: isActive,
                    onChanged: (value) {
                      setState(() {
                        isActive = value;
                        debugPrint('isActive switched to: $isActive');
                      });
                    },
                    activeColor: Colors.green,
                    activeTrackColor: Colors.greenAccent,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: _saveItem,
                child: const Text('Salvar', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
