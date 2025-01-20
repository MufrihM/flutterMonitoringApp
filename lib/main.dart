import 'package:flutter/material.dart';
import 'package:monitoring_app/mqtt/mqtt_service.dart';
import '../components/loading_screen.dart';
import '../pages/login.dart';
import '../pages/register.dart';
import '../pages/home.dart';
import '../pages/detail_suhu.dart';
import '../pages/detail_lembap.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MqttService mqttService = MqttService();
  double tempMessage = 0;
  double humidMessage = 0;

  void _onMessageReceived(String topic, double message) {
    setState(() {
      if (topic == 'temp/mufrih') {
        tempMessage = message;
        print('Tempertature: $message');
      } else if (topic == 'humid/mufrih') {
        humidMessage = message;
        print('Humidity: $message');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    mqttService.onMessageReceived = _onMessageReceived;
    mqttService.connect();
  }

  @override
  void dispose() {
    mqttService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoadingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(tempMessage: tempMessage, humidMessage: humidMessage),
        '/suhu': (context) => TemperatureScreen(currentTemp: tempMessage),
        '/kelembapan': (context) => HumidityScreen(currentHumid: humidMessage),
      },
    );
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid); 

  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(MyApp());
}