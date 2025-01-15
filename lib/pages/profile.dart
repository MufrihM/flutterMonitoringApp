import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> _profileData;

  Future<String> _getJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? ''; // Ambil token dari shared_preferences
  }

  Future<String> _getUserId(String jwtToken) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id') ?? '';
  }

  @override
  void initState() {
    super.initState();
    _profileData = _fetchProfileData();
  }

  Future<Map<String, dynamic>> _fetchProfileData() async {
    final jwtToken = await _getJwtToken(); // Ambil token dari shared_preferences
    final userId = await _getUserId(jwtToken);
    final apiService = ApiService();
    return apiService.getProfile(userId, jwtToken);
  }

  Future<void> _updateProfile(Map<String, dynamic> updatedData) async {
    final jwtToken = await _getJwtToken();
    final userId = await _getUserId(jwtToken);
    final apiService = ApiService();
    await apiService.updateProfile(userId, jwtToken, updatedData);
    // Refresh data setelah update
    setState(() {
      _profileData = _fetchProfileData();
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus semua data di shared_preferences
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
    ); // Navigasi ke halaman login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Data tidak tersedia'));
          }

          final data = snapshot.data!;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ]
                    ),
                    child: Center(
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1), // Kolom pertama lebih kecil
                          1: FlexColumnWidth(2), // Kolom kedua lebih besar
                        },
                        children: [
                          _buildTableRow('Username', data['username']),
                          _buildTableRow('Email', data['email']),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              //   Tombol edit
                ElevatedButton(
                    onPressed: (){
                      _showEditDialog(data);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Ubah Data',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                      ),
                    )
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                        'Logout',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                      ),
                    )
                )
              ],
            ),
          );
        },
      ),
    );
  }

// Fungsi untuk membuat baris pada tabel
  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  void _showEditDialog(Map<String, dynamic> data) {
    final usernameController = TextEditingController(text: data['username']);
    final emailController = TextEditingController(text: data['email']);

    // Menampilkan pop up edit
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text('Ubah data diri'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'username'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'email'),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
              onPressed: () {
                final updatedData = {
                  'username': usernameController.text,
                  'email': emailController.text,
                };
                _updateProfile(updatedData);
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
          )
        ],
      );
    });
  }
}
