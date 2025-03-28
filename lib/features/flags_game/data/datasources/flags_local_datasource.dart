import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gardas/core/constants/app_constants.dart';
import 'package:gardas/core/error/exceptions.dart';
import 'package:gardas/data/datasources/local/local_storage_service.dart';
import 'package:gardas/domain/entities/game.dart';
import 'package:gardas/features/flags_game/data/models/flag_models.dart';

/// Flags local data source
/// 
/// This class provides methods for retrieving flag data locally.
class FlagsLocalDataSource {
  final LocalStorageService _storageService;
  List<FlagOptionModel> _allFlags = [];
  final Random _random = Random();

  /// Constructor for FlagsLocalDataSource
  FlagsLocalDataSource(this._storageService);

  /// Initializes the data source
  /// 
  /// This method should be called before using the data source.
  Future<void> init() async {
    if (_allFlags.isEmpty) {
      await _loadFlags();
    }
  }

  /// Loads flag data from the assets
  Future<void> _loadFlags() async {
    try {
      // Load from JSON asset
      final String data = await rootBundle.loadString('assets/data/countries.json');
      final List<dynamic> jsonList = json.decode(data);
      
      _allFlags = jsonList.map((json) => FlagOptionModel.fromJson(json)).toList();
      
      // Ensure data is loaded
      if (_allFlags.isEmpty) {
        throw CacheException(
          message: 'No flag data loaded',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading flags: $e');
      }
      throw CacheException(
        message: 'Failed to load flag data',
        details: e.toString(),
      );
    }
  }

  /// Gets all flag options
  /// 
  /// Returns a list of [FlagOptionModel] objects.
  Future<List<FlagOptionModel>> getAllFlagOptions() async {
    if (_allFlags.isEmpty) {
      await init();
    }
    return _allFlags;
  }

  /// Gets a list of random flag questions
  /// 
  /// [difficulty] is the difficulty level.
  /// [count] is the number of questions to generate.
  /// Returns a list of [FlagQuestionModel] objects.
  Future<List<FlagQuestionModel>> getFlagQuestions({
    required GameDifficulty difficulty,
    required int count,
  }) async {
    if (_allFlags.isEmpty) {
      await init();
    }

    try {
      final questions = <FlagQuestionModel>[];
      final usedFlags = <String>{};
      final int optionsCount = _getDifficultyOptionsCount(difficulty);
      
      // Generate questions
      for (int i = 0; i < count; i++) {
        // Find a flag that hasn't been used yet
        FlagOptionModel correctOption;
        do {
          correctOption = _allFlags[_random.nextInt(_allFlags.length)];
        } while (usedFlags.contains(correctOption.countryCode) && usedFlags.length < _allFlags.length);
        
        // Mark as used
        usedFlags.add(correctOption.countryCode);
        
        // Generate wrong options
        final options = <FlagOptionModel>[correctOption];
        final wrongOptions = List<FlagOptionModel>.from(_allFlags);
        wrongOptions.remove(correctOption);
        wrongOptions.shuffle(_random);
        
        // Add enough wrong options to meet the difficulty level
        options.addAll(wrongOptions.take(optionsCount - 1));
        
        // Shuffle options
        options.shuffle(_random);
        
        // Create question
        final question = FlagQuestionModel(
          id: 'q_${DateTime.now().millisecondsSinceEpoch}_$i',
          correctOption: correctOption,
          options: options,
          difficulty: difficulty,
        );
        
        questions.add(question);
      }
      
      return questions;
    } catch (e) {
      if (kDebugMode) {
        print('Error generating flag questions: $e');
      }
      throw CacheException(
        message: 'Failed to generate flag questions',
        details: e.toString(),
      );
    }
  }

  /// Gets a flag score
  /// 
  /// [id] is the ID of the score.
  /// Returns a [FlagScoreModel] if found, null otherwise.
  Future<FlagScoreModel?> getFlagScore(String id) async {
    try {
      return _storageService.getObject<FlagScoreModel>(
        AppConstants.scoresBoxName,
        id,
        FlagScoreModel.fromJson,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error getting flag score: $e');
      }
      throw CacheException(
        message: 'Failed to get flag score',
        details: e.toString(),
      );
    }
  }

  /// Gets all flag scores
  /// 
  /// Returns a list of [FlagScoreModel] objects.
  Future<List<FlagScoreModel>> getAllFlagScores() async {
    try {
      final allData = _storageService.getAll(AppConstants.scoresBoxName);
      final scores = <FlagScoreModel>[];
      
      for (final entry in allData.entries) {
        try {
          final Map<String, dynamic> data = Map<String, dynamic>.from(entry.value);
          if (data['game_id'] == 'flags_game') {
            scores.add(FlagScoreModel.fromJson(data));
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error parsing flag score: $e');
          }
          // Skip invalid entries
        }
      }
      
      return scores;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting all flag scores: $e');
      }
      throw CacheException(
        message: 'Failed to get all flag scores',
        details: e.toString(),
      );
    }
  }

  /// Gets flag scores by user
  /// 
  /// [userId] is the ID of the user.
  /// Returns a list of [FlagScoreModel] objects.
  Future<List<FlagScoreModel>> getFlagScoresByUser(String userId) async {
    try {
      final allScores = await getAllFlagScores();
      return allScores.where((score) => score.userId == userId).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting flag scores by user: $e');
      }
      throw CacheException(
        message: 'Failed to get flag scores by user',
        details: e.toString(),
      );
    }
  }

  /// Saves a flag score
  /// 
  /// [score] is the score to save.
  /// Returns the saved [FlagScoreModel].
  Future<FlagScoreModel> saveFlagScore(FlagScoreModel score) async {
    try {
      await _storageService.putObject<FlagScoreModel>(
        AppConstants.scoresBoxName,
        score.id,
        score,
        (score) => score.toJson(),
      );
      return score;
    } catch (e) {
      if (kDebugMode) {
        print('Error saving flag score: $e');
      }
      throw CacheException(
        message: 'Failed to save flag score',
        details: e.toString(),
      );
    }
  }

  /// Gets the highest flag score for a specific difficulty
  /// 
  /// [difficulty] is the difficulty level.
  /// [userId] is the optional ID of the user.
  /// Returns the highest [FlagScoreModel] if found, null otherwise.
  Future<FlagScoreModel?> getHighestFlagScore({
    required GameDifficulty difficulty,
    String? userId,
  }) async {
    try {
      List<FlagScoreModel> scores;
      
      if (userId != null) {
        scores = await getFlagScoresByUser(userId);
      } else {
        scores = await getAllFlagScores();
      }
      
      // Filter by difficulty
      scores = scores.where((score) => score.difficulty == difficulty).toList();
      
      if (scores.isEmpty) {
        return null;
      }
      
      // Sort by value (descending)
      scores.sort((a, b) => b.value.compareTo(a.value));
      
      return scores.first;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting highest flag score: $e');
      }
      throw CacheException(
        message: 'Failed to get highest flag score',
        details: e.toString(),
      );
    }
  }

  /// Gets the number of options based on difficulty
  int _getDifficultyOptionsCount(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return 2;
      case GameDifficulty.medium:
        return 3;
      case GameDifficulty.hard:
        return 4;
    }
  }
}