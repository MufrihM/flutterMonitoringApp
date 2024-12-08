import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ScrollableLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> temperatureData = List.generate(
    100,
        (index) => {
      'time': '${10 + index ~/ 10}:${(index % 10) * 6}'.padLeft(2, '0'),
      'temperature': 25 + (index % 5) * 0.5,
    },
  );

  List<FlSpot> getTemperatureSpots(List<Map<String, dynamic>> data) {
    return data.asMap().entries.map((entry) {
      String time = entry.value['time'];
      double temperature = entry.value['temperature'];
      List<String> timeParts = time.split(':');
      double xValue = double.parse(timeParts[0]) + (double.parse(timeParts[1]) / 60);

      return FlSpot(xValue, temperature);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final spots = getTemperatureSpots(temperatureData);

    return Scaffold(
      appBar: AppBar(
        title: Text('Scrollable Line Chart'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Scroll ke kiri/kanan
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical, // Scroll ke atas/bawah
          child: Container(
            width: 1200, // Lebar lebih besar dari viewport untuk scroll horizontal
            height: 600, // Tinggi lebih besar dari viewport untuk scroll vertikal
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()} \u00B0C');
                      },
                      interval: 1,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int hour = value.toInt();
                        int minute = ((value - hour) * 60).toInt();
                        return Text('$hour:${minute.toString().padLeft(2, '0')}');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 4,
                    spots: spots,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: ScrollableLineChart()));
}
