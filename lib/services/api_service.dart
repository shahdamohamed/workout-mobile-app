import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exercise.dart';

/// Service class for fetching exercise data from the API.
class ApiService {
  /// Base URL for fetching chest exercises.
  static const String baseUrl =
      'https://exercisedb.p.rapidapi.com/exercises/bodyPart/chest';

  /// Headers required for the RapidAPI request.
  /// Note: In production, store API keys securely.
  static const Map<String, String> headers = {
    'X-RapidAPI-Key': '41871bdc2cmshda4b55f799b56f0p1795f5jsn58f799554aee',
    'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com',
  };

  /// Fetches a list of chest exercises from the API.
  /// Throws an [Exception] if the request fails.
  static Future<List<Exercise>> fetchExercises() async {
    final response = await http.get(Uri.parse(baseUrl), headers: headers);

    if (response.statusCode == 200) {
      // Parse the response body as a list of exercises.
      final List data = json.decode(response.body);
      return data.map((json) => Exercise.fromJson(json)).toList();
    } else {
      // Throw an exception if the API call was not successful.
      throw Exception('Failed to load exercises');
    }
  }
}
