import 'package:flutter/material.dart';
import '../services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Provider to manage the current user and persist user data.
class UserProvider extends ChangeNotifier {
  User? _currentUser;
  static const String _currentUserKey = 'current_user';

  /// Getter for the current user.
  User? get currentUser => _currentUser;

  /// Initializes the provider by loading the saved user from preferences.
  Future<void> initialize() async {
    await loadSavedUser();
  }

  /// Sets the current user, saves to preferences, and notifies listeners.
  Future<void> setCurrentUser(User user) async {
    _currentUser = user;
    await _saveUserToPrefs();
    notifyListeners();
  }

  /// Logs out the user, clears from preferences, and notifies listeners.
  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
    notifyListeners();
  }

  /// Loads the saved user from preferences, if available.
  Future<void> loadSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_currentUserKey);

    if (userJson != null) {
      try {
        _currentUser = User.fromJson(json.decode(userJson));
        notifyListeners();
      } catch (e) {
        // Handle parsing error by clearing the user.
        _currentUser = null;
      }
    }
  }

  /// Saves the current user to preferences.
  Future<void> _saveUserToPrefs() async {
    if (_currentUser == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, json.encode(_currentUser!.toJson()));
  }
}
