import 'package:flutter/foundation.dart';
import 'package:gardas/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Preferences service using SharedPreferences
/// 
/// This service provides methods for storing and retrieving simple preferences.
class PreferencesService {
  late SharedPreferences _prefs;

  /// Initializes the preferences service
  /// 
  /// This method should be called before using the service.
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing preferences: $e');
      }
      throw CacheException(
        message: 'Failed to initialize preferences',
        details: e.toString(),
      );
    }
  }

  /// Gets a string value
  /// 
  /// [key] is the key of the value.
  /// [defaultValue] is the default value to return if the key doesn't exist.
  /// Returns the string value.
  String getString(String key, {String defaultValue = ''}) {
    try {
      return _prefs.getString(key) ?? defaultValue;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting string from preferences: $e');
      }
      throw CacheException(
        message: 'Failed to get string from preferences',
        details: e.toString(),
      );
    }
  }

  /// Sets a string value
  /// 
  /// [key] is the key of the value.
  /// [value] is the value to store.
  Future<bool> setString(String key, String value) async {
    try {
      return await _prefs.setString(key, value);
    } catch (e) {
      if (kDebugMode) {
        print('Error setting string to preferences: $e');
      }
      throw CacheException(
        message: 'Failed to set string to preferences',
        details: e.toString(),
      );
    }
  }

  /// Gets a boolean value
  /// 
  /// [key] is the key of the value.
  /// [defaultValue] is the default value to return if the key doesn't exist.
  /// Returns the boolean value.
  bool getBool(String key, {bool defaultValue = false}) {
    try {
      return _prefs.getBool(key) ?? defaultValue;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting boolean from preferences: $e');
      }
      throw CacheException(
        message: 'Failed to get boolean from preferences',
        details: e.toString(),
      );
    }
  }

  /// Sets a boolean value
  /// 
  /// [key] is the key of the value.
  /// [value] is the value to store.
  Future<bool> setBool(String key, bool value) async {
    try {
      return await _prefs.setBool(key, value);
    } catch (e) {
      if (kDebugMode) {
        print('Error setting boolean to preferences: $e');
      }
      throw CacheException(
        message: 'Failed to set boolean to preferences',
        details: e.toString(),
      );
    }
  }

  /// Gets an integer value
  /// 
  /// [key] is the key of the value.
  /// [defaultValue] is the default value to return if the key doesn't exist.
  /// Returns the integer value.
  int getInt(String key, {int defaultValue = 0}) {
    try {
      return _prefs.getInt(key) ?? defaultValue;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting integer from preferences: $e');
      }
      throw CacheException(
        message: 'Failed to get integer from preferences',
        details: e.toString(),
      );
    }
  }

  /// Sets an integer value
  /// 
  /// [key] is the key of the value.
  /// [value] is the value to store.
  Future<bool> setInt(String key, int value) async {
    try {
      return await _prefs.setInt(key, value);
    } catch (e) {
      if (kDebugMode) {
        print('Error setting integer to preferences: $e');
      }
      throw CacheException(
        message: 'Failed to set integer to preferences',
        details: e.toString(),
      );
    }
  }

  /// Gets a double value
  /// 
  /// [key] is the key of the value.
  /// [defaultValue] is the default value to return if the key doesn't exist.
  /// Returns the double value.
  double getDouble(String key, {double defaultValue = 0.0}) {
    try {
      return _prefs.getDouble(key) ?? defaultValue;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting double from preferences: $e');
      }
      throw CacheException(
        message: 'Failed to get double from preferences',
        details: e.toString(),
      );
    }
  }

  /// Sets a double value
  /// 
  /// [key] is the key of the value.
  /// [value] is the value to store.
  Future<bool> setDouble(String key, double value) async {
    try {
      return await _prefs.setDouble(key, value);
    } catch (e) {
      if (kDebugMode) {
        print('Error setting double to preferences: $e');
      }
      throw CacheException(
        message: 'Failed to set double to preferences',
        details: e.toString(),
      );
    }
  }

  /// Gets a list of strings
  /// 
  /// [key] is the key of the value.
  /// Returns the list of strings or an empty list if the key doesn't exist.
  List<String> getStringList(String key) {
    try {
      return _prefs.getStringList(key) ?? [];
    } catch (e) {
      if (kDebugMode) {
        print('Error getting string list from preferences: $e');
      }
      throw CacheException(
        message: 'Failed to get string list from preferences',
        details: e.toString(),
      );
    }
  }

  /// Sets a list of strings
  /// 
  /// [key] is the key of the value.
  /// [value] is the list to store.
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await _prefs.setStringList(key, value);
    } catch (e) {
      if (kDebugMode) {
        print('Error setting string list to preferences: $e');
      }
      throw CacheException(
        message: 'Failed to set string list to preferences',
        details: e.toString(),
      );
    }
  }

  /// Removes a value
  /// 
  /// [key] is the key of the value to remove.
  Future<bool> remove(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (e) {
      if (kDebugMode) {
        print('Error removing value from preferences: $e');
      }
      throw CacheException(
        message: 'Failed to remove value from preferences',
        details: e.toString(),
      );
    }
  }

  /// Checks if a key exists
  /// 
  /// [key] is the key to check.
  /// Returns true if the key exists, false otherwise.
  bool containsKey(String key) {
    try {
      return _prefs.containsKey(key);
    } catch (e) {
      if (kDebugMode) {
        print('Error checking key in preferences: $e');
      }
      throw CacheException(
        message: 'Failed to check key in preferences',
        details: e.toString(),
      );
    }
  }

  /// Clears all preferences
  Future<bool> clear() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing preferences: $e');
      }
      throw CacheException(
        message: 'Failed to clear preferences',
        details: e.toString(),
      );
    }
  }
}