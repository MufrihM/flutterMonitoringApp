import 'package:flutter/material.dart';
import 'mqtt/mqtt_service.dart';
import 'services/api_service.dart';
import 'pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MqttService mqttService = MqttService(
    'broker.emqx.io',
    ['/temp/demo', '/humid/demo'],
    ApiService(),
  );

  String tempMessage = '';
  String humidMessage = '';

  void _onMessageReceived(String topic, String message) {
    setState(() {
      if (topic == '/temp/demo') {
        tempMessage = message;
      } else if (topic == '/humid/demo') {
        humidMessage = message;
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
      home: HomeScreen(
        tempMessage: tempMessage,
        humidMessage: humidMessage,
      )
    );
  }
}
