import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_navbar.dart';
import '../components/data_terkini.dart';
import '../components/grafik_data.dart';
import '../components/table_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TemperatureScreen extends StatefulWidget {
  final double currentTemp;

  const TemperatureScreen({
    required this.currentTemp,
    Key? key
  }) : super(key: key);

  @override
  State<TemperatureScreen> createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
  ApiService apiService = ApiService();
  List<dynamic> tempList = [];
  bool isLoading = true;
  String stringTemp = "";

  Future<String> _getJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? '';
  }

  @override
  void initState(){
    super.initState();
    stringTemp = "${widget.currentTemp}\u00B0C";

    fetchTempData(); //ambil data dari api
  }

  Future<void> fetchTempData() async {
    try{
      final jwtToken = await _getJwtToken();
      List<dynamic> data = await apiService.getTemp(jwtToken);
      print(data);
      setState(() {
        tempList = data;
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
              DataTerkini(currentData: stringTemp, dataName: "Suhu Terkini"),
              const SizedBox(height: 20),

              // ============== Grafik RIwayat Suhu ===============
              GrafikData(dataList: tempList, grafikName: "Riwayat Suhu"),
              const SizedBox(height: 20),

              // ========== Table Riwayat Suhu ========
              TableData(tableName: "Data Riwayat Suhu", tema: "Suhu", tableList: tempList),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
    );
  }
}
