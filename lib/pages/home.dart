import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String tempMessage;
  final String humidMessage;

  // Constructor untuk menerima data dari main.dart
  HomeScreen({required this.tempMessage, required this.humidMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT Flutter Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Temperature Data: $tempMessage'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tempatkan fungsi publish jika ada
              },
              child: const Text('Publish Message'),
            ),
            const SizedBox(height: 50),
            Text('Humidity Data: $humidMessage'),
            ElevatedButton(
              onPressed: () {
                // Tempatkan fungsi publish jika ada
              },
              child: const Text('Publish Message'),
            ),
          ],
        ),
      ),
    );
  }
}
