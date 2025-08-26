import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/measurement.dart';

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = 'http://localhost:8000'});

  Future<DeviceData> fetchDeviceData() async {
    final uri = Uri.parse('$baseUrl/data');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded =
          json.decode(response.body) as Map<String, dynamic>;
      return DeviceData.fromJson(decoded);
    }
    throw Exception('Failed to load data: ${response.statusCode}');
  }
}
