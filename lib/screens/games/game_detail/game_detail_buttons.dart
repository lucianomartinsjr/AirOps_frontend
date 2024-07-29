import 'package:flutter/material.dart';

class GameDetailButtons extends StatelessWidget {
  final bool isError;
  final bool isSuccess;
  final String errorMessage;
  final VoidCallback onMapTap;
  final VoidCallback onInscreverTap;
  final bool isSubscribed; // Adicione esta linha

  const GameDetailButtons({
    super.key,
    required this.isError,
    required this.isSuccess,
    required this.errorMessage,
    required this.onMapTap,
    required this.onInscreverTap,
    required this.isSubscribed, // Adicione esta linha
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
                backgroundColor: isSubscribed
                    ? const Color.fromARGB(
                        255, 95, 0, 0) // Cor para desinscrição
                    : const Color.fromARGB(
                        255, 0, 119, 54), // Cor para inscrição
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isSubscribed ? 'Desinscrever' : 'Inscrever',
                style: const TextStyle(fontSize: 18),
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
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }
}
