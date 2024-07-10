import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/airsoft_service.dart';
import '../models/game.dart';

class CreateGameScreen extends StatelessWidget {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  final _fieldTypeController = TextEditingController();
  final _modalityController = TextEditingController();
  final _periodController = TextEditingController();
  final _organizerController = TextEditingController();
  final _feeController = TextEditingController();
  final _imageUrlController = TextEditingController();

  CreateGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Novo Jogo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    _dateController.text =
                        pickedDate.toString().substring(0, 10);
                  }
                },
              ),
              TextField(
                controller: _fieldTypeController,
                decoration: const InputDecoration(labelText: 'Field Type'),
              ),
              TextField(
                controller: _modalityController,
                decoration: const InputDecoration(labelText: 'Modality'),
              ),
              TextField(
                controller: _periodController,
                decoration: const InputDecoration(labelText: 'Period'),
              ),
              TextField(
                controller: _feeController,
                decoration: const InputDecoration(labelText: 'Fee'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final newGame = Game(
                    id: DateTime.now().toString(),
                    name: _nameController.text,
                    location: _locationController.text,
                    date: DateTime.parse(_dateController.text),
                    fieldType: _fieldTypeController.text,
                    modality: _modalityController.text,
                    period: _periodController.text,
                    organizer: _organizerController.text,
                    fee: double.parse(_feeController.text),
                    imageUrl: _imageUrlController.text,
                  );
                  Provider.of<AirsoftService>(context, listen: false)
                      .addGame(newGame);
                  Navigator.of(context).pop();
                },
                child: const Text('Create Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
