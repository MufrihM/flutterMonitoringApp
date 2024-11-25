import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService{
  final String baseUrl = 'http://10.0.2.2:5000';
  
  //   Fungsi Login
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password})
    );

    if (response.statusCode == 200){
      return jsonDecode(response.body); //jwt token
    } else {
      return {'error': 'Failed to login'};
    }
  }

  //   Fungsi Registrasi
  // Future<Map<String, dynamic>> register
      
}