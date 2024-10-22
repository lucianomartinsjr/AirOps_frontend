import 'package:flutter/material.dart';
import '../../utils/cities.dart';
import 'date_picker_field.dart';
import 'custom_dropdown_form_field.dart';

class FilterDialog extends StatefulWidget {
  final TextEditingController cityController;
  final TextEditingController dateController;
  final bool isFree;
  final String selectedPeriod;
  final String selectedModality;
  final Function(String, String, bool, String, String) onApplyFilters;
  final List<String> modalityOptions;

  const FilterDialog({
    super.key,
    required this.cityController,
    required this.dateController,
    required this.isFree,
    required this.selectedPeriod,
    required this.selectedModality,
    required this.onApplyFilters,
    required this.modalityOptions,
  });

  @override
  FilterDialogState createState() => FilterDialogState();
}

class FilterDialogState extends State<FilterDialog> {
  late bool _isFree;
  late String _selectedPeriod;
  late String _selectedModality;

  @override
  void initState() {
    super.initState();
    _isFree = widget.isFree;
    _selectedPeriod = widget.selectedPeriod;
    _selectedModality = widget.selectedModality;
  }

  void _clearFilters() {
    setState(() {
      widget.cityController.clear();
      widget.dateController.clear();
      _isFree = false;
      _selectedPeriod = 'Any';
      _selectedModality = 'Any';
    });
  }

  bool get _areFiltersApplied {
    return widget.cityController.text.isNotEmpty ||
        widget.dateController.text.isNotEmpty ||
        _isFree ||
        _selectedPeriod != 'Any' ||
        _selectedModality != 'Any';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[800],
      title: const Text(
        'Filtrar por',
        style: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildFilterSection(
                  'Data',
                  DatePickerField(
                    controller: widget.dateController,
                    labelText: 'Selecione uma data',
                  )),
              _buildFilterSection(
                  'Cidade',
                  CidadesUtil.construirCampoAutocompleteCidade(
                    controller: widget.cityController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    readOnly: false,
                  )),
              _buildFilterSection(
                  'Período',
                  CustomDropdownFormField(
                    value: _selectedPeriod,
                    items: const ['Any', 'Matutino', 'Vespertino', 'Noturno'],
                    labelText: 'Escolha o período',
                    readOnly: false,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPeriod = newValue!;
                      });
                    },
                    prefixIcon: const Icon(Icons.access_time),
                  )),
              _buildFilterSection(
                  'Modalidade',
                  CustomDropdownFormField(
                    value: _selectedModality,
                    items: ['Any', ...widget.modalityOptions],
                    labelText: 'Selecione a modalidade',
                    readOnly: false,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedModality = newValue!;
                      });
                    },
                    prefixIcon: const Icon(Icons.category),
                  )),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text(
                  'Apenas eventos gratuitos',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                value: _isFree,
                onChanged: (bool value) {
                  setState(() {
                    _isFree = value;
                  });
                },
                activeColor: Colors.red,
                secondary:
                    const Icon(Icons.monetization_on, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: [
            if (_areFiltersApplied)
              TextButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.clear, color: Colors.red),
                label: const Text(
                  'Limpar Filtros',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
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
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text(
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
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        content,
        const SizedBox(height: 24),
      ],
    );
  }
}
