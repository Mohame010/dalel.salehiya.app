import 'dart:convert';
import 'package:http/http.dart' as http;

import 'storage_service.dart';

class ApiService {
  static const String baseUrl = "https://api.dalelsalehiya.shop"; // عدل ده

  /// 📌 Headers
  static Future<Map<String, String>> getHeaders() async {
    final token = await StorageService.getToken();

    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  /// 📥 GET
  static Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: await getHeaders(),
    );

    return _handleResponse(response);
  }

  /// 📤 POST
  static Future<dynamic> post(String endpoint, Map data) async {
    final response = await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: await getHeaders(),
      body: jsonEncode(data),
    );

    return _handleResponse(response);
  }

  /// 📌 Response Handler
  static dynamic _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data['message'] ?? "Error");
    }
  }
}