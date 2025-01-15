import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService{
  final String baseUrl = 'http://10.0.2.2:5000';

  // Get data temperature
  Future<List<dynamic>> getTemp(String token) async {
    final response = await http.get(
        Uri.parse('$baseUrl/temp'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }
    );

    if (response.statusCode == 200){
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data Temperature, Error: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> getHumid(String token) async {
    final response = await http.get(
        Uri.parse('$baseUrl/humid'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }
    );

    if (response.statusCode == 200){
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data Temperature, Error: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getProfile(String userId, String token) async {

    final response = await http.get(
        Uri.parse('$baseUrl/users/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
    );

    if (response.statusCode == 200){
      return jsonDecode(response.body);
    } else if (response.statusCode == 404){
      throw Exception('User not found');
    } else {
      throw Exception('Failed to load data Temperature, Error: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> updateProfile(String userId, String token, Map<String, dynamic> updatedData) async {
    final url = Uri.parse('$baseUrl/users/$userId');

    try {
      // Kirim permintaan HTTP PUT
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token', // JWT token sebagai header
          'Content-Type': 'application/json'
        },
        body: jsonEncode(updatedData), // Data yang akan diperbarui
      );

      // Periksa status kode
      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Data yang diperbarui
      } else {
        throw Exception('Failed to update profile: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }
}