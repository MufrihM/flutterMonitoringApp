import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_navbar.dart';
import '../components/data_terkini.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final double tempMessage;
  final double humidMessage;

  // Constructor untuk menerima data dari main.dart
  HomeScreen({required this.tempMessage, required this.humidMessage});
  // print(tempMessage);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String stringTemp = "";
  String stringHumid = "";

  @override
  void initState(){
    super.initState();
    stringTemp = "${widget.tempMessage}\u00b0C";
    stringHumid = "${widget.humidMessage} %";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(pageName: "Monitoring App"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ====================== SUHU ===========================
            // DataTerkini(currentData: stringTemp, dataName: "Suhu"),
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
                      const Text(
                        'Suhu',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.tempMessage} \u00B0C', // Data suhu ditampilkan di sini
                        style: const TextStyle(
                          fontSize: 50,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.thermostat,
                    size: 100,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            // ===================== KELEMBAPAN ======================
            // DataTerkini(currentData: stringHumid, dataName: "Humid"),
            // const SizedBox(height: 20),
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
                      const Text(
                        'Kelembapan',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.humidMessage} %', // Data kelembapan ditampilkan di sini
                        style: const TextStyle(
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
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}
