import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  MqttServerClient? client;
  final String broker = 'broker.hivemq.com';
  final FlutterLocalNotificationsPlugin notif = FlutterLocalNotificationsPlugin();
  Function(String, double)? onMessageReceived;

  MqttService() {
    // Initialize the notification plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    notif.initialize(initializationSettings);
  }

  Future<void> _showNotification(String title, String body) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alert_channel', 'Alerts',
      channelDescription: 'Notifications for alerts temperature and humidity',
      importance: Importance.max, priority: Priority.high, showWhen: false,
      icon: 'ic_launcher',
    );
    const platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await notif.show(0, title, body, platformChannelSpecifics);
  }

  Future<void> connect() async {
    client = MqttServerClient(broker, '');
    client!.logging(on: true);
    client!.setProtocolV311();
    client!.keepAlivePeriod = 20;
    client!.onDisconnected = _onDisconnected;
    client!.onConnected = _onConnected;
    client!.onSubscribed = _onSubscribed;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .withWillQos(MqttQos.atMostOnce);
    client!.connectionMessage = connMessage;

    try {
      await client!.connect();
      _subscribeToTopics();
    } catch (e) {
      print('ERROR: $e');
      disconnect();
    }
  }

  void _subscribeToTopics() {
    if (client!.connectionStatus!.state == MqttConnectionState.connected) {
      client!.subscribe('temp/mufrih', MqttQos.atMostOnce);
      client!.subscribe('humid/mufrih', MqttQos.atMostOnce);
      client!.updates!.listen(_onMessage);
      print('Subscribed to topics');
    }
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> event) {
    final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
    final String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    final String topic = event[0].topic;
    print('Message: $message from topic: $topic');

    final data = jsonDecode(message);
    if (data.containsKey('temp')) {
      double tempValue = data['temp'].toDouble();
      if(tempValue > 30){
        _showNotification('Peringatan suhu!', 'Suhu melebihi batas: ${tempValue}\u00b0C');
      }
      if (onMessageReceived != null) {
        onMessageReceived!(topic, tempValue);
      }
    }
    if (data.containsKey('humid')) {
      double humidValue = data['humid'].toDouble();
      if(humidValue < 80){
        _showNotification('Peringata kelembapan!', 'Kelembapan melebihi batas: ${humidValue}%');
      }
      if (onMessageReceived != null) {
        onMessageReceived!(topic, humidValue);
      }
    }
  }

  void _onDisconnected() {
    print('Disconnected');
  }

  void _onConnected() {
    print('Connected to MQTT');
  }

  void _onSubscribed(String topic) {
    print('Subscribed to $topic');
  }

  void disconnect() {
    client?.disconnect();
  }
}