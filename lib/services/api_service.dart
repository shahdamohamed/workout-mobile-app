import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exercise.dart';

class ApiService {
  static const String baseUrl =
      'https://exercisedb.p.rapidapi.com/exercises/bodyPart/chest';

  static const Map<String, String> headers = {
    'X-RapidAPI-Key': '41871bdc2cmshda4b55f799b56f0p1795f5jsn58f799554aee', // ← حطي API Key هنا
    'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com',
  };

  static Future<List<Exercise>> fetchExercises() async {
    final response = await http.get(Uri.parse(baseUrl), headers: headers);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Exercise.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }
}

