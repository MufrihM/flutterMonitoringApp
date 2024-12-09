import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
    {'id': 1, 'temperature': 27.5, 'time': '10:00'},
    {'id': 2, 'temperature': 28.0, 'time': '11:00'},
    {'id': 3, 'temperature': 28.3, 'time': '12:00'},
    {'id': 4, 'temperature': 28.5, 'time': '13:00'},
  ];

  // convert data temperatureDetails to FlSpots
  List<FlSpot> getTemperatureSpots(List<Map<String, dynamic>> data) {
    return data.asMap().entries.map((entry) {
      int index = entry.key; // Gunakan indeks jika waktu tidak relevan sebagai x
      double temperature = entry.value['temperature']; // Ambil nilai suhu

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Temperature Monitoring"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              // Aksi untuk tombol profil
            },
            icon: const Icon(Icons.person),
          ),
        ],
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
            icon: Icon(Icons.water),
            label: 'kelembapan',
          ),
        ],
        currentIndex: 1, // Indeks halaman suhu
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
              // ===================== Suhu Terkini ==================
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
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
                child: Column(
                  children: [
                    const Text(
                      "Suhu Terkini",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "$currentTemperature\u00B0C",
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ============== Grafik RIwayat Suhu ===============
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Riwayat Suhu",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      "Tanggal: ${selectedDate.toLocal().toString().split(' ')[0]}",
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
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
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        )
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          reservedSize: 33,
                          showTitles: true,
                          getTitlesWidget: (value, meta){
                            return Text(
                              '${value.toDouble()}',
                            );
                          },
                          interval: 1,
                        ),
                      ),
                        bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                                reservedSize: 33,
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text('${value.toInt()}');
                                },
                              interval: 1,
                            ),
                        ),
                    ),
                    borderData: FlBorderData(show: false,),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 4,
                        spots: getTemperatureSpots(temperatureDetails),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ========== Table Riwayat Suhu ========
              const Text(
                "Detail Riwayat Suhu",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              Table(
                border: TableBorder.all(color: Colors.blue),
                columnWidths: const {
                  0: FixedColumnWidth(40),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                },
                children: [
                  // Header tabel
                  TableRow(
                    decoration: const BoxDecoration(color: Colors.blueAccent),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "No",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Suhu",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Waktu",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Isi tabel
                  ...temperatureDetails.map(
                        (data) => TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(data['id'].toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${data['temperature']}\u00B0C"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(data['time']),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
