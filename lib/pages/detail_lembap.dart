import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../components/data_terkini.dart';
import '../components/grafik_data.dart';
import '../components/table_data.dart';

class RiwayatSuhuPage extends StatefulWidget {
  const RiwayatSuhuPage({Key? key}) : super(key: key);

  @override
  State<RiwayatSuhuPage> createState() => _RiwayatSuhuPageState();
}

class _RiwayatSuhuPageState extends State<RiwayatSuhuPage> {
  String currentData = "30.0";
  String dataName = "Suhu Terkini";
  DateTime selectedDate = DateTime.now(); // Tanggal yang dipilih
  List<Map<String, dynamic>> temperatureData = List.generate(
    500,
        (index) => {
      'time': '${10 + index ~/ 10}:${(index % 10) * 6}'.padLeft(2, '0'),
      'temperature': 25 + (index % 5) * 0.5,
    },
  ); // Dummy Data Riwayat Suhu
  List<Map<String, dynamic>> temperatureDetails = [
    {'id': 1, 'content': 27.5, 'time': '10:00'},
    {'id': 2, 'content': 28.0, 'time': '11:00'},
    {'id': 3, 'content': 28.3, 'time': '12:00'},
    {'id': 4, 'content': 28.5, 'time': '13:00'},
  ];

  // Fungsi untuk memilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Fungsi konversi data ke FlSpot
  List<FlSpot> getTemperatureSpots(List<Map<String, dynamic>> data) {
    return data.asMap().entries.map((entry) {
      String time = entry.value['time'];
      double temperature = entry.value['temperature'];
      List<String> timeParts = time.split(':');
      double xValue =
          double.parse(timeParts[0]) + (double.parse(timeParts[1]) / 60);

      return FlSpot(xValue, temperature);
    }).toList();
  }

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = getTemperatureSpots(temperatureData);
    print(spots.length);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Kelembapan"),
        backgroundColor: Colors.blue,
        centerTitle: true,
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
        currentIndex: 1, // Indeks halaman ini
        onTap: (index) {
          // Navigasi antar halaman
        },
        selectedItemColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ========== SUHU TERKINI ==========
              DataTerkini(currentData: currentData, dataName: dataName),
              const SizedBox(height: 20),

              // ========== GRAFIK RIWAYAT SUHU ==========
              GrafikData(spotsData: spots, grafikName: "Data Riwayat Suhu"),
              const SizedBox(height: 20),

              // ========== TABEL RIWAYAT SUHU ==========
              TableData(tableName: "Tabel Riwayat Suhu", tema: "Suhu", tableList: temperatureDetails),
            ],
          ),
        ),
      ),
    );
  }
}
