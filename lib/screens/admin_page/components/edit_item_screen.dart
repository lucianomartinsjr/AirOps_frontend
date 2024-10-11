import 'package:flutter/material.dart';
import '../../../models/class.dart';
import '../../../models/modality.dart';
import '../../../widgets/form_fields/custom_text_form_field.dart';

class EditItemScreen extends StatefulWidget {
  final String title;
  final Map<String, TextEditingController> controllers;
  final bool isActive;
  final Function(bool isActive) onSave;
  final Modality? initialModality;
  final Class? initialClass;

  const EditItemScreen({
    super.key,
    required this.title,
    required this.controllers,
    required this.isActive,
    required this.onSave,
    this.initialModality,
    this.initialClass,
  });

  @override
  EditItemScreenState createState() => EditItemScreenState();
}

class EditItemScreenState extends State<EditItemScreen> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.isActive;
    debugPrint('Initial isActive in EditItemScreen: $isActive');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isModality = widget.initialModality != null;
    final id =
        isModality ? widget.initialModality?.id : widget.initialClass?.id;
    final criadoEm = isModality
        ? widget.initialModality?.criadoEM
        : widget.initialClass?.criadoEm;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style:
                theme.textTheme.headlineMedium?.copyWith(color: Colors.white)),
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.primaryColor, theme.scaffoldBackgroundColor],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (id != null) ...[
                  _buildInfoCard(
                    'ID',
                    id.toString(),
                    Icons.fingerprint,
                  ),
                  const SizedBox(height: 16.0),
                  if (criadoEm != null)
                    _buildInfoCard(
                      'Data de Criação',
                      _formatDate(criadoEm),
                      Icons.calendar_today,
                    ),
                  const SizedBox(height: 24.0),
                ],
                ..._buildFormFields(),
                const SizedBox(height: 16.0),
                _buildActiveSwitch(),
                const SizedBox(height: 24.0),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Card(
      elevation: 2,
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 12.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    return widget.controllers.entries.map((entry) {
      final label = entry.key;
      final controller = entry.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: CustomTextFormField(
          controller: controller,
          labelText: label,
          readOnly: false,
          maxLines: label == 'Regras' || label == 'Descrição' ? 5 : 1,
        ),
      );
    }).toList();
  }

  Widget _buildActiveSwitch() {
    return Card(
      elevation: 2,
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Ativo',
                style: TextStyle(fontSize: 16, color: Colors.white)),
            Switch(
              value: isActive,
              onChanged: (value) {
                setState(() {
                  isActive = value;
                  debugPrint('isActive switched to: $isActive');
                });
              },
              activeColor: Colors.red,
              activeTrackColor: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.save),
        label: const Text('Salvar', style: TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: () {
          widget.onSave(isActive);
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
