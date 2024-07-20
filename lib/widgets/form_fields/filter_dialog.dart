import 'package:flutter/material.dart';
import 'date_picker_field.dart';
import 'custom_dropdown_form_field.dart';
import 'city_autocomplete_field.dart'; // Certifique-se de ajustar o caminho para onde o CityAutocompleteField está localizado

class FilterDialog extends StatefulWidget {
  final TextEditingController cityController;
  final TextEditingController dateController;
  final bool isFree;
  final String selectedPeriod;
  final String selectedModality;
  final String selectedFieldType;
  final Function(String, String, bool, String, String, String) onApplyFilters;
  final List<String> cityOptions;

  const FilterDialog({
    super.key,
    required this.cityController,
    required this.dateController,
    required this.isFree,
    required this.selectedPeriod,
    required this.selectedModality,
    required this.selectedFieldType,
    required this.onApplyFilters,
    required this.cityOptions,
  });

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late bool _isFree;
  late String _selectedPeriod;
  late String _selectedModality;
  late String _selectedFieldType;

  @override
  void initState() {
    super.initState();
    _isFree = widget.isFree;
    _selectedPeriod =
        widget.selectedPeriod == 'Any' ? '-' : widget.selectedPeriod;
    _selectedModality =
        widget.selectedModality == 'Any' ? '-' : widget.selectedModality;
    _selectedFieldType =
        widget.selectedFieldType == 'Any' ? '-' : widget.selectedFieldType;
  }

  void _clearFilters() {
    setState(() {
      widget.cityController.clear();
      widget.dateController.clear();
      _isFree = false;
      _selectedPeriod = '-';
      _selectedModality = '-';
      _selectedFieldType = '-';
    });
  }

  bool get _areFiltersApplied {
    return widget.cityController.text.isNotEmpty ||
        widget.dateController.text.isNotEmpty ||
        _isFree ||
        _selectedPeriod != '-' ||
        _selectedModality != '-' ||
        _selectedFieldType != '-';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[800],
      title: const Text(
        'Filtrar por',
        style: TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              DatePickerField(
                controller: widget.dateController,
                labelText: 'Data',
              ),
              const SizedBox(height: 16),
              CityAutocompleteField(
                controller: widget.cityController,
                cityOptions: widget.cityOptions,
                labelText: 'Cidade',
              ),
              const SizedBox(height: 16),
              CustomDropdownFormField(
                value: _selectedPeriod,
                items: const ['-', 'Matutino', 'Vespertino', 'Noturno'],
                labelText: 'Período',
                readOnly: false,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPeriod = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomDropdownFormField(
                value: _selectedModality,
                items: ['-', 'Modalidade 1', 'Modalidade 2', 'Modalidade 3'],
                labelText: 'Modalidade',
                readOnly: false,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedModality = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomDropdownFormField(
                value: _selectedFieldType,
                items: ['-', 'Indoor', 'Outdoor'],
                labelText: 'Tipo de Campo',
                readOnly: false,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFieldType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text(
                  'Gratuito',
                  style: TextStyle(color: Colors.white),
                ),
                value: _isFree,
                onChanged: (bool value) {
                  setState(() {
                    _isFree = value;
                  });
                },
                activeColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: const Text(
                'Aplicar',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () {
                widget.onApplyFilters(
                  widget.cityController.text,
                  widget.dateController.text,
                  _isFree,
                  _selectedPeriod,
                  _selectedModality,
                  _selectedFieldType,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        if (_areFiltersApplied)
          Center(
            child: TextButton(
              onPressed: _clearFilters,
              child: const Text(
                'Limpar Filtros',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ),
      ],
    );
  }
}
