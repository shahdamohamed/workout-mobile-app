import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Model class representing a user.
class User {
  final String name;
  final String email;
  final String password;

  /// Creates a [User] instance.
  User({
    required this.name,
    required this.email,
    required this.password,
  });

  /// Converts a [User] object to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }

  /// Factory constructor to create a [User] from a JSON map.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }
}

/// Service class for user-related operations and persistence.
class UserService {
  static const String _usersKey = 'users';

  /// Retrieves all registered users from persistent storage.
  static Future<List<User>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_usersKey) ?? [];
    return usersJson
        .map((userStr) => User.fromJson(json.decode(userStr)))
        .toList();
  }

  /// Checks if a user with the given email exists.
  static Future<bool> userExists(String email) async {
    final users = await getUsers();
    return users.any((user) => user.email.toLowerCase() == email.toLowerCase());
  }

  /// Validates login credentials and returns the user if valid.
  static Future<User?> validateLogin(String email, String password) async {
    final users = await getUsers();
    try {
      return users.firstWhere(
        (user) =>
            user.email.toLowerCase() == email.toLowerCase() &&
            user.password == password,
      );
    } catch (e) {
      return null; // User not found or password incorrect
    }
  }

  /// Registers a new user. Returns false if the user already exists.
  static Future<bool> registerUser(User newUser) async {
    // Check if user already exists
    final exists = await userExists(newUser.email);
    if (exists) {
      return false; // User already exists
    }

    // Get existing users
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_usersKey) ?? [];

    // Add new user
    usersJson.add(json.encode(newUser.toJson()));

    // Save updated list
    return prefs.setStringList(_usersKey, usersJson);
  }

  /// Updates an existing user by email. Returns false if user not found.
  static Future<bool> updateUser(String oldEmail, User updatedUser) async {
    // Get all users
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_usersKey) ?? [];
    final users = usersJson
        .map((userStr) => User.fromJson(json.decode(userStr)))
        .toList();

    // Find the user to update
    final userIndex = users.indexWhere(
      (user) => user.email.toLowerCase() == oldEmail.toLowerCase(),
    );

    if (userIndex == -1) {
      return false; // User not found
    }

    // Update the user
    users[userIndex] = updatedUser;

    // Convert back to JSON strings
    final updatedUsersJson =
        users.map((user) => json.encode(user.toJson())).toList();

    // Save updated list
    return prefs.setStringList(_usersKey, updatedUsersJson);
  }
}
