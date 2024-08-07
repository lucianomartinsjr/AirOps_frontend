import 'package:flutter/material.dart';
import '../../../models/modality.dart';
import '../../../widgets/form_fields/custom_text_form_field.dart';

class EditItemScreen extends StatefulWidget {
  final String title;
  final Map<String, TextEditingController> controllers;
  final bool isActive;
  final VoidCallback onSave;
  final Modality? initialModality;

  const EditItemScreen({
    super.key,
    required this.title,
    required this.controllers,
    required this.isActive,
    required this.onSave,
    this.initialModality,
  });

  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.isActive;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: widget.onSave,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (widget.initialModality != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID: ${widget.initialModality!.id}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 129, 129, 129),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Data de Criação: ${widget.initialModality!.criadoEM.toLocal().toString().split(' ')[0]}',
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
                  maxLines: label == 'Regras' ? 5 : 1,
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
                      });
                    },
                    activeColor: Colors.green, // Cor do switch
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
                  backgroundColor: Colors.red, // Cor do texto do botão
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: widget.onSave,
                child: const Text('Salvar', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
