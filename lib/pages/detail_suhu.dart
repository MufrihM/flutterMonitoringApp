import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_navbar.dart';
import '../components/data_terkini.dart';
import '../components/grafik_data.dart';
import '../components/table_data.dart';

class TemperatureScreen extends StatefulWidget {
  const TemperatureScreen({Key? key}) : super(key: key);

  @override
  State<TemperatureScreen> createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
  String currentTemperature = "28.5"; // Suhu terkini
  DateTime selectedDate = DateTime.now(); // Tanggal yang dipilih
  List<double> temperatureHistory = [27.5, 28.0, 28.3, 28.5, 28.8, 29.0]; // Riwayat suhu sementara
  List<Map<String, dynamic>> temperatureDetails = [
    {'id': 1, 'content': 27.5, 'time': '10:00'},
    {'id': 2, 'content': 28.0, 'time': '11:00'},
    {'id': 3, 'content': 28.3, 'time': '12:00'},
    {'id': 4, 'content': 28.5, 'time': '13:00'},
  ];

  List<Map<String, dynamic>> temperatureData = List.generate(
    40,
        (index) => {
      'time': '${10 + index ~/ 10}:${(index % 10) * 6}'.padLeft(2, '0'),
      'content': index.toDouble(),
    },
  ); //data dummy

  // convert data temperatureDetails to FlSpots
  List<FlSpot> getTemperatureSpots(List<Map<String, dynamic>> data) {
    return data.asMap().entries.map((entry) {
      double temperature = entry.value['content']; // Ambil nilai suhu

      // Konversi waktu ke nilai x, jika dibutuhkan
      String time = entry.value['time']; // Contoh: '10:00'
      List<String> timeParts = time.split(':');
      double xValue = double.parse(timeParts[0]) + (double.parse(timeParts[1]) / 60); // 10:30 -> 10.5

      return FlSpot(xValue, temperature); // (x = waktu, y = suhu)
    }).toList();
  }

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

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = getTemperatureSpots(temperatureData);
    print(spots);

    return Scaffold(
      appBar: const CustomAppBar(pageName: "Data Suhu"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ===================== Suhu Terkini ==================
              DataTerkini(currentData: currentTemperature, dataName: "Suhu Terkini"),
              const SizedBox(height: 20),

              // ============== Grafik RIwayat Suhu ===============
              GrafikData(spotsData: spots, grafikName: "Riwayat Suhu"),
              const SizedBox(height: 20),

              // ========== Table Riwayat Suhu ========
              TableData(tableName: "Data Riwayat Suhu", tema: "Suhu", tableList: temperatureDetails),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
    );
  }
}
