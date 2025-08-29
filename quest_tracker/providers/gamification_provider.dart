import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/achievement.dart';
import '../models/quest_data.dart';
import '../utils/constants.dart';

class GamificationState {
  final int totalXP;
  final int level;
  final int currentLevelXP;
  final int nextLevelXP;
  final int totalQuestsCompleted;
  final int longestStreak;
  final int currentStreak;
  final List<Achievement> unlockedAchievements;

  const GamificationState({
    this.totalXP = 0,
    this.level = 1,
    this.currentLevelXP = 0,
    this.nextLevelXP = 100,
    this.totalQuestsCompleted = 0,
    this.longestStreak = 0,
    this.currentStreak = 0,
    this.unlockedAchievements = const [],
  });

  GamificationState copyWith({
    int? totalXP,
    int? level,
    int? currentLevelXP,
    int? nextLevelXP,
    int? totalQuestsCompleted,
    int? longestStreak,
    int? currentStreak,
    List<Achievement>? unlockedAchievements,
  }) {
    return GamificationState(
      totalXP: totalXP ?? this.totalXP,
      level: level ?? this.level,
      currentLevelXP: currentLevelXP ?? this.currentLevelXP,
      nextLevelXP: nextLevelXP ?? this.nextLevelXP,
      totalQuestsCompleted: totalQuestsCompleted ?? this.totalQuestsCompleted,
      longestStreak: longestStreak ?? this.longestStreak,
      currentStreak: currentStreak ?? this.currentStreak,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
    );
  }
}

class GamificationNotifier extends StateNotifier<GamificationState> {
  GamificationNotifier() : super(const GamificationState());

  void addXP(int xp) {
    final newTotalXP = state.totalXP + xp;
    final newLevel = _calculateLevel(newTotalXP);
    final levelXP = _getLevelXP(newLevel);

    state = state.copyWith(
      totalXP: newTotalXP,
      level: newLevel,
      currentLevelXP: newTotalXP % levelXP,
      nextLevelXP: levelXP,
    );
  }

  void questCompleted(QuestData questData) {
    final baseXP = QuestConstants.baseXP;
    final difficultyMultiplier = questData.difficulty.multiplier;
    final streakBonus = questData.streak * QuestConstants.streakBonus;
    final totalXP = ((baseXP * difficultyMultiplier) + streakBonus).round();

    addXP(totalXP);

    state = state.copyWith(
      totalQuestsCompleted: state.totalQuestsCompleted + 1,
      currentStreak: questData.streak,
      longestStreak: questData.streak > state.longestStreak
          ? questData.streak
          : state.longestStreak,
    );
  }

  int _calculateLevel(int totalXP) {
    return (totalXP / 100).floor() + 1;
  }

  int _getLevelXP(int level) {
    return 100 + ((level - 1) * 50);
  }
}

final gamificationProvider = StateNotifierProvider<GamificationNotifier, GamificationState>((ref) {
  return GamificationNotifier();
});

// Extension pour les imports manquants
// import 'dart:math' show cos, sin;