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
        toolbarHeight: 60,
        title: Padding(
          padding: EdgeInsets.all(10),
          child: const Text(
            'Monitoring App',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 18),
              child: GestureDetector(
                onTap: () {
                //   Aksi ketika icon diklik
                },
                child: Icon(
                    Icons.person,
                    size: 30,
                  ),
                ),
              ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ========== SUHU ============
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          'Suhu',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700
                          ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$tempMessage \u00B0C', // Data suhu ditampilkan di sini
                        style: TextStyle(
                          fontSize: 50,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.thermostat,
                    size: 100,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // ========== Kelembapan ============
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Kelembapan',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '$humidMessage %', // Data kelembapan ditampilkan di sini
                        style: TextStyle(
                          fontSize: 50,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.water_drop,
                    size: 100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thermostat),
            label: 'suhu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.water_drop),
            label: 'kelembapan',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Aksi navigasi berdasarkan indeks tombol navbar
          switch (index) {
            case 0:
            // Beranda
              break;
            case 1:
            // Navigasi ke halaman suhu
              Navigator.pushNamed(context, '/suhu');
              break;
            case 2:
            // Navigasi ke halaman kelembapan
              Navigator.pushNamed(context, '/kelembapan');
              break;
          }
        },
      ),
    );
  }
}
