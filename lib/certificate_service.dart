import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/certificate.dart';

class CertificateService {
  // aa470430fe4d4758a26d0997d61f01de
  final String apiUrl = 'https://newsapi.org/v2/top-headlines/sources?apiKey=aa470430fe4d4758a26d0997d61f01de'; // Ganti dengan URL API Anda

  Future<List<Certificate>> fetchCertificates() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      
      // Pastikan data['sources'] adalah list
      if (data['sources'] is List) {
        List<dynamic> sources = data['sources'];
        return sources.map((json) => Certificate.fromJson(json)).toList();
      } else {
        throw Exception('Unexpected JSON format: ${data['sources']}');
      }
    } else {
      throw Exception('Failed to load certificates');
    }
  }
}
