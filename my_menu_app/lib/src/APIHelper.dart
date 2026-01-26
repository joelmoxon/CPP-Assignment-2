import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService({required this.baseUrl});

  final String baseUrl;

  static const apiKey = 'api_warehouse_student_key_1234567890abcdef';

  Map<String, String> _jsonHeaders() => {
        'Content-Type': 'application/json',
      };

  Map<String, String> _authHeaders() => {
        ..._jsonHeaders(),
        'X-API-Key': apiKey,
      };

  Future<Map<String, dynamic>> createLog({
    required String title,
    required String description,
    required String priority,
    required String status,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/logs'),
      headers: _authHeaders(),
      body: jsonEncode({
        'title': title,
        'description': description,
        'priority': priority,
        'status': status,
        'user_id': null, // TODO consider devloping this feature
      }),
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}