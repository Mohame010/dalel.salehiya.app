import 'dart:convert';
import 'package:http/http.dart' as http;

import 'storage_service.dart';

class ApiService {
  static const String baseUrl = "https://api.dalelsalehiya.shop";

  /// 📌 Headers
  static Future<Map<String, String>> getHeaders() async {
    final token = await StorageService.getToken();

    print("🔑 TOKEN: $token"); // 🔥 debug

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
      print("❌ GET ERROR: $e");
      throw Exception("Network Error ❌");
    }
  }

  /// 📤 POST
  static Future<dynamic> post(String endpoint, Map data) async {
    try {
      final url = "$baseUrl$endpoint";

      print("🚀 POST → $url");
      print("📦 BODY → $data");

      final response = await http.post(
        Uri.parse(url),
        headers: await getHeaders(),
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      print("❌ POST ERROR: $e");
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
      print("❌ DELETE ERROR: $e");
      throw Exception("Network Error ❌");
    }
  }

  /// 🔍 SEARCH
  static Future<dynamic> search(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);

      final response = await http.get(
        Uri.parse("$baseUrl/search?q=$encodedQuery"),
        headers: await getHeaders(),
      );

      return _handleResponse(response);
    } catch (e) {
      print("❌ SEARCH ERROR: $e");
      throw Exception("Search Error ❌");
    }
  }

  /// 📌 Response Handler (🔥 أهم تعديل)
  static dynamic _handleResponse(http.Response response) {
    print("📡 STATUS: ${response.statusCode}");
    print("📡 RESPONSE: ${response.body}");

    dynamic data;

    try {
      data = jsonDecode(response.body);
    } catch (e) {
      throw Exception("Invalid JSON ❌");
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(
        "Error ${response.statusCode}: ${data is Map ? data['message'] : data}",
      );
    }
  }
}