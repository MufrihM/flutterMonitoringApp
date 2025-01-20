import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class GrafikData extends StatefulWidget {
  final List<dynamic> dataList;
  final String grafikName;

  const GrafikData({
    required this.dataList,
    required this.grafikName,
    // required this.dateData,
    super.key
  });

  @override
  State<GrafikData> createState() => _GrafikDataState();
}

class _GrafikDataState extends State<GrafikData> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectedDate(BuildContext context) async{
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

  String convertRfc1123ToIso8601(String rfc1123Timestamp) {
    try {
      DateFormat format = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", "en_US");
      DateTime entryDate = format.parseUtc(rfc1123Timestamp).toUtc();
      return entryDate.toIso8601String();
    } catch (e) {
      print("Error parsing RFC 1123: $rfc1123Timestamp | Error: $e");
      return ""; // Mengembalikan string kosong jika parsing gagal
    }
  }


  List<FlSpot> filterDataByDate(List<dynamic> data, DateTime selectedDate) {
    return data.where((entry) {
      try {
        if (entry['timestamp'] == null || entry['timestamp'].isEmpty) {
          print("Empty or null timestamp: ${entry['timestamp']}");
          return false;
        }

        // Parsing timestamp ISO 8601
        DateTime entryDate = DateTime.parse(entry['timestamp']).toLocal();

        // Memeriksa apakah tanggal sesuai dengan tanggal yang dipilih
        return entryDate.year == selectedDate.year &&
            entryDate.month == selectedDate.month &&
            entryDate.day == selectedDate.day;
      } catch (e) {
        print("Error parsing ISO 8601 timestamp: ${entry['timestamp']} | Error: $e");
        return false;
      }
    }).map((entry) {
      try {
        // Parsing timestamp
        DateTime entryDate = DateTime.parse(entry['timestamp']).toLocal();

        // Konversi waktu ke nilai X untuk grafik
        double xValue = entryDate.hour + (entryDate.minute / 60);

        // Nilai Y dari data
        double yValue = entry['message'];
        return FlSpot(xValue, yValue);
      } catch (e) {
        print("Error creating FlSpot: ${entry['timestamp']} | Error: $e");
        return null; // Abaikan entry yang tidak valid
      }
    }).whereType<FlSpot>().toList();
  }




  @override
  Widget build(BuildContext context) {
    final filteredSpots = filterDataByDate(widget.dataList, selectedDate);
    // print(filteredSpots);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.grafikName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            ElevatedButton(
                onPressed: () => _selectedDate(context),
                child: Text(
                  "Tanggal: ${selectedDate.toLocal().toString().split(' ')[0]}",
                  style: const TextStyle(color: Colors.blue),
                )
            ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: 1000,
              height: (filteredSpots.length*20).toDouble().clamp(100.0, 400.0),
              padding: const EdgeInsets.all(16),
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
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    verticalInterval: 0.25,
                    getDrawingVerticalLine: (value) => FlLine(
                      color: Colors.grey,
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    ),
                    drawHorizontalLine: true,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey,
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    )
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      )
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      )
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int hour = value.toInt();
                          int minute = ((value-hour) * 60).toInt();
                          return Text('$hour: ${minute.toString().padLeft(2, '0')}');
                        },
                        interval: 0.25,
                      )
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int temp = value.toInt();
                          return Text('$temp');
                        },
                        interval: 1,
                      )
                    )
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 4,
                      spots: filteredSpots,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
