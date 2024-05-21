import 'dart:convert';

import 'package:http/http.dart' as http;

import '../method/sheradPrefefrancesManger.dart';
import '../models/concpt.dart';
import '../models/paths.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  Future<List<ProgrammingPath>> fetchPaths() async {
    final prefs = await SharedPreferencesManager.getInstance();
    final token = prefs.getString('auth') ?? '';

    final response = await http.get(
      Uri.parse('$baseUrl/student/paths'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> pathsJson = data['paths'];
      return pathsJson.map((json) => ProgrammingPath.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load paths');
    }
  }

  Future<ProgrammingPath> fetchPath(int id) async {
    final prefs = await SharedPreferencesManager.getInstance();
    final token = prefs.getString('auth') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/student/paths/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProgrammingPath.fromJson(data['path']);
    } else {
      throw Exception('Failed to load this path');
    }
  }

  Future<Map<String, List<Concept>>> fetchAndGroupConcepts() async {
    var url = Uri.parse('http://127.0.0.1:8000/api/student/concepts');
    final prefs = await SharedPreferencesManager.getInstance();
    final token = prefs.getString('auth') ?? '';
    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List<dynamic> conceptsJson = jsonResponse['concepts'];
      List<Concept> concepts =
          conceptsJson.map((concept) => Concept.fromJson(concept)).toList();
      Map<String, List<Concept>> grouped = {};
      for (var concept in concepts) {
        if (!grouped.containsKey(concept.topicName)) {
          grouped[concept.topicName!] = [];
        }
        grouped[concept.topicName]!.add(concept);
      }
      return grouped;
    } else {
      throw Exception('Failed to load concpts');
    }
  }
}
