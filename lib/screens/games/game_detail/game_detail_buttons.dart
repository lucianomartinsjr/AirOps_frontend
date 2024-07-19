import 'package:flutter/material.dart';

class GameDetailButtons extends StatelessWidget {
  final bool isError;
  final bool isSuccess;
  final String errorMessage;
  final VoidCallback onMapTap;
  final VoidCallback onInscreverTap;

  const GameDetailButtons({
    super.key,
    required this.isError,
    required this.isSuccess,
    required this.errorMessage,
    required this.onMapTap,
    required this.onInscreverTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onMapTap,
              label: const Text(
                'Link do Campo',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              icon: const Icon(
                Icons.map_outlined,
                size: 24,
                color: Colors.green,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: const BorderSide(color: Colors.green),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onInscreverTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 243, 33, 33),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Inscrever',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          if (isError)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          if (isSuccess)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Inscrição realizada com sucesso!',
                style: TextStyle(color: Colors.green),
              ),
            ),
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }
}
