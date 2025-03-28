import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gardas/core/constants/app_constants.dart';
import 'package:gardas/core/error/exceptions.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

/// Local storage service using Hive
/// 
/// This service provides methods for storing and retrieving data locally.
class LocalStorageService {
  /// Initializes the local storage service
  /// 
  /// This method should be called before using the service.
  Future<void> init() async {
    try {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocumentDir.path);
      
      // Open boxes
      await Hive.openBox(AppConstants.userBoxName);
      await Hive.openBox(AppConstants.settingsBoxName);
      await Hive.openBox(AppConstants.scoresBoxName);
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing local storage: $e');
      }
      throw CacheException(
        message: 'Failed to initialize local storage',
        details: e.toString(),
      );
    }
  }

  /// Gets a value from the specified box
  /// 
  /// [boxName] is the name of the box.
  /// [key] is the key of the value.
  /// Returns the value as a dynamic object.
  dynamic get(String boxName, String key) {
    try {
      final box = Hive.box(boxName);
      return box.get(key);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting data from local storage: $e');
      }
      throw CacheException(
        message: 'Failed to get data from local storage',
        details: e.toString(),
      );
    }
  }

  /// Puts a value in the specified box
  /// 
  /// [boxName] is the name of the box.
  /// [key] is the key of the value.
  /// [value] is the value to store.
  Future<void> put(String boxName, String key, dynamic value) async {
    try {
      final box = Hive.box(boxName);
      await box.put(key, value);
    } catch (e) {
      if (kDebugMode) {
        print('Error putting data to local storage: $e');
      }
      throw CacheException(
        message: 'Failed to put data to local storage',
        details: e.toString(),
      );
    }
  }

  /// Deletes a value from the specified box
  /// 
  /// [boxName] is the name of the box.
  /// [key] is the key of the value.
  Future<void> delete(String boxName, String key) async {
    try {
      final box = Hive.box(boxName);
      await box.delete(key);
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting data from local storage: $e');
      }
      throw CacheException(
        message: 'Failed to delete data from local storage',
        details: e.toString(),
      );
    }
  }

  /// Clears all values from the specified box
  /// 
  /// [boxName] is the name of the box.
  Future<void> clear(String boxName) async {
    try {
      final box = Hive.box(boxName);
      await box.clear();
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing data from local storage: $e');
      }
      throw CacheException(
        message: 'Failed to clear data from local storage',
        details: e.toString(),
      );
    }
  }

  /// Gets all values from the specified box
  /// 
  /// [boxName] is the name of the box.
  /// Returns a map of all key-value pairs.
  Map<dynamic, dynamic> getAll(String boxName) {
    try {
      final box = Hive.box(boxName);
      return Map<dynamic, dynamic>.from(box.toMap());
    } catch (e) {
      if (kDebugMode) {
        print('Error getting all data from local storage: $e');
      }
      throw CacheException(
        message: 'Failed to get all data from local storage',
        details: e.toString(),
      );
    }
  }

  /// Gets all keys from the specified box
  /// 
  /// [boxName] is the name of the box.
  /// Returns a list of all keys.
  List<dynamic> getAllKeys(String boxName) {
    try {
      final box = Hive.box(boxName);
      return box.keys.toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting all keys from local storage: $e');
      }
      throw CacheException(
        message: 'Failed to get all keys from local storage',
        details: e.toString(),
      );
    }
  }

  /// Gets an object from the specified box and deserializes it
  /// 
  /// [boxName] is the name of the box.
  /// [key] is the key of the value.
  /// [fromJson] is a function that converts a JSON map to an object.
  /// Returns the deserialized object.
  T? getObject<T>(String boxName, String key, T Function(Map<String, dynamic>) fromJson) {
    try {
      final data = get(boxName, key);
      if (data == null) {
        return null;
      }
      
      if (data is String) {
        // If the data is stored as a JSON string, parse it
        final Map<String, dynamic> jsonMap = jsonDecode(data);
        return fromJson(jsonMap);
      } else if (data is Map) {
        // If the data is already a map
        return fromJson(Map<String, dynamic>.from(data));
      } else {
        throw CacheException(
          message: 'Failed to parse data from local storage',
          details: 'Data is not in expected format',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting object from local storage: $e');
      }
      throw CacheException(
        message: 'Failed to get object from local storage',
        details: e.toString(),
      );
    }
  }

  /// Puts an object in the specified box after serializing it
  /// 
  /// [boxName] is the name of the box.
  /// [key] is the key of the value.
  /// [value] is the object to store.
  /// [toJson] is a function that converts an object to a JSON map.
  Future<void> putObject<T>(
    String boxName, 
    String key, 
    T value, 
    Map<String, dynamic> Function(T) toJson,
  ) async {
    try {
      final jsonMap = toJson(value);
      // Store it as a map rather than a string to avoid JSON conversion issues
      await put(boxName, key, jsonMap);
    } catch (e) {
      if (kDebugMode) {
        print('Error putting object to local storage: $e');
      }
      throw CacheException(
        message: 'Failed to put object to local storage',
        details: e.toString(),
      );
    }
  }

  /// Gets a list of objects from the specified box and deserializes them
  /// 
  /// [boxName] is the name of the box.
  /// [fromJson] is a function that converts a JSON map to an object.
  /// Returns a list of deserialized objects.
  List<T> getAllObjects<T>(
    String boxName, 
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      final allData = getAll(boxName);
      final objects = <T>[];
      
      for (final value in allData.values) {
        if (value is String) {
          // If the data is stored as a JSON string, parse it
          final Map<String, dynamic> jsonMap = jsonDecode(value);
          objects.add(fromJson(jsonMap));
        } else if (value is Map) {
          // If the data is already a map
          objects.add(fromJson(Map<String, dynamic>.from(value)));
        }
      }
      
      return objects;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting all objects from local storage: $e');
      }
      throw CacheException(
        message: 'Failed to get all objects from local storage',
        details: e.toString(),
      );
    }
  }

  /// Closes the local storage service
  ///
  /// This method should be called when the service is no longer needed.
  Future<void> close() async {
    try {
      await Hive.close();
    } catch (e) {
      if (kDebugMode) {
        print('Error closing local storage: $e');
      }
      throw CacheException(
        message: 'Failed to close local storage',
        details: e.toString(),
      );
    }
  }
}