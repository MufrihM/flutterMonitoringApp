import 'package:flutter/material.dart';
import '../components/data_terkini.dart';
import '../components/grafik_data.dart';
import '../components/table_data.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_navbar.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HumidityScreen extends StatefulWidget {
  final double currentHumid;

  const HumidityScreen({
    required this.currentHumid,
    Key? key
  }) : super(key: key);

  @override
  State<HumidityScreen> createState() => _HumidityScreenState();
}

class _HumidityScreenState extends State<HumidityScreen> {
  ApiService apiService = ApiService();
  List<dynamic> humidList = [];
  bool isLoading = true;
  String stringHumid = "";

  Future<String> _getJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? '';
  }

  @override
  void initState(){
    super.initState();
    stringHumid = "${widget.currentHumid}%";

    fetchHumidData();
  }

  Future<void> fetchHumidData() async {
    try{
      final jwtToken = await _getJwtToken();
      List<dynamic> data = await apiService.getHumid(jwtToken);
      print(data);
      setState(() {
        humidList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // List<FlSpot> spots = getTemperatureSpots(temperatureData);
    // print(spots.length);

    return Scaffold(
      appBar: const CustomAppBar(pageName: "Data Kelembapan"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ===================== Suhu Terkini ==================
              DataTerkini(currentData: stringHumid, dataName: "Kelembapan Terkini"),
              const SizedBox(height: 20),

              // ============== Grafik RIwayat Suhu ===============
              GrafikData(dataList: humidList, grafikName: "Riwayat Kelembapan"),
              const SizedBox(height: 20),

              // ========== Table Riwayat Suhu ========
              TableData(tableName: "Data Riwayat Kelembapan", tema: "Kelembapan", tableList: humidList),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
    );
  }
}
