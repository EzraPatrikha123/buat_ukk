import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://ukk-p2.smktelkom-mlg.sch.id/api';
  
  // Get stored token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  
  // Save token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
  
  // Get user role from stored token (simplified)
  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole');
  }
  
  // Save user role
  static Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userRole', role);
  }
  static Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
  
  // ============ AUTH ============
  
  // Login
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Login failed');
    }
  }
  
  // Register Siswa
  static Future<Map<String, dynamic>> registerSiswa(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/siswa'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }
  
  // Register Admin Stan
  static Future<Map<String, dynamic>> registerAdmin(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/admin'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }
  
  // Logout
  static Future<void> logout() async {
    final headers = await getHeaders();
    await http.post(Uri.parse('$baseUrl/logout'), headers: headers);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userRole');
  }
  
  // ============ STAN ============
  
  // Get all stan
  static Future<List<dynamic>> getAllStan() async {
    final headers = await getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/stan'), headers: headers);
    final data = jsonDecode(response.body);
    return data['data'] ?? [];
  }
  
  // Get stan by ID
  static Future<Map<String, dynamic>> getStanById(int id) async {
    final headers = await getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/stan/$id'), headers: headers);
    return jsonDecode(response.body);
  }
  
  // ============ MENU ============
  
  // Get menu by stan
  static Future<List<dynamic>> getMenuByStan(int stanId) async {
    final headers = await getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/menu/stan/$stanId'), headers: headers);
    final data = jsonDecode(response.body);
    return data['data'] ?? [];
  }
  
  // CRUD Menu (Admin)
  static Future<Map<String, dynamic>> createMenu(Map<String, dynamic> data) async {
    final headers = await getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/menu'),
      headers: headers,
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }
  
  static Future<Map<String, dynamic>> updateMenu(int id, Map<String, dynamic> data) async {
    final headers = await getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/menu/$id'),
      headers: headers,
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }
  
  static Future<void> deleteMenu(int id) async {
    final headers = await getHeaders();
    await http.delete(Uri.parse('$baseUrl/menu/$id'), headers: headers);
  }
  
  // ============ TRANSAKSI ============
  
  // Create order
  static Future<Map<String, dynamic>> createTransaksi(Map<String, dynamic> data) async {
    final headers = await getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/transaksi'),
      headers: headers,
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }
  
  // Get transaksi siswa
  static Future<List<dynamic>> getTransaksiSiswa() async {
    final headers = await getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/transaksi/siswa'), headers: headers);
    final data = jsonDecode(response.body);
    return data['data'] ?? [];
  }
  
  // Get transaksi stan (admin)
  static Future<List<dynamic>> getTransaksiStan() async {
    final headers = await getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/transaksi/stan'), headers: headers);
    final data = jsonDecode(response.body);
    return data['data'] ?? [];
  }
  
  // Update status transaksi (admin)
  static Future<Map<String, dynamic>> updateStatusTransaksi(int id, String status) async {
    final headers = await getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/transaksi/$id/status'),
      headers: headers,
      body: jsonEncode({'status': status}),
    );
    return jsonDecode(response.body);
  }
  
  // ============ PELANGGAN (Admin) ============
  
  static Future<List<dynamic>> getAllPelanggan() async {
    final headers = await getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/pelanggan'), headers: headers);
    final data = jsonDecode(response.body);
    return data['data'] ?? [];
  }
  
  // ============ DISKON ============
  
  static Future<List<dynamic>> getActiveDiskon() async {
    final headers = await getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/diskon'), headers: headers);
    final data = jsonDecode(response.body);
    return data['data'] ?? [];
  }
}
