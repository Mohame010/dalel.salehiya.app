import 'dart:convert';
import 'package:http/http.dart' as http;

import 'storage_service.dart';

class ApiService {
  static const String baseUrl = "https://api.dalelsalehiya.shop";

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
    try {
      final response = await http.get(
        Uri.parse("$baseUrl$endpoint"),
        headers: await getHeaders(),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception("Network Error ❌");
    }
  }

  /// 📤 POST
  static Future<dynamic> post(String endpoint, Map data) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl$endpoint"),
        headers: await getHeaders(),
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception("Network Error ❌");
    }
  }

  /// ❌ DELETE
  static Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl$endpoint"),
        headers: await getHeaders(),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception("Network Error ❌");
    }
  }

  /// 🔍 SEARCH (🔥 الجديد)
  static Future<dynamic> search(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);

      final response = await http.get(
        Uri.parse("$baseUrl/search?q=$encodedQuery"),
        headers: await getHeaders(),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception("Search Error ❌");
    }
  }

  /// 📌 Response Handler
  static dynamic _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        throw Exception(data['message'] ?? "Server Error ❌");
      }
    } catch (e) {
      throw Exception("Invalid Response ❌");
    }
  }
}