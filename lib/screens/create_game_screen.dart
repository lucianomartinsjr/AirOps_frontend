import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/airsoft_service.dart';
import '../models/game.dart';

class CreateGameScreen extends StatelessWidget {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Novo Jogo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date'),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  _dateController.text = pickedDate.toString().substring(0, 10);
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newGame = Game(
                  id: DateTime.now().toString(),
                  name: _nameController.text,
                  location: _locationController.text,
                  date: DateTime.parse(_dateController.text),
                );
                Provider.of<AirsoftService>(context, listen: false)
                    .addGame(newGame);
                Navigator.of(context).pop();
              },
              child: Text('Create Game'),
            ),
          ],
        ),
      ),
    );
  }
}
