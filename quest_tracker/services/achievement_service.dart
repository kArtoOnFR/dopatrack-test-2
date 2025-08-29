import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/achievement.dart';
import '../utils/constants.dart';



class AchievementService extends StateNotifier<List<Achievement>> {
  AchievementService() : super(_defaultAchievements);

  static final List<Achievement> _defaultAchievements = [
    Achievement(
      id: 'first_quest',
      title: 'Première Quête',
      description: 'Complète ta première quête',
      icon: '🎯',
      color: Colors.blue,
    ),
    Achievement(
      id: 'streak_3',
      title: 'Série de 3',
      description: 'Maintiens une série de 3 jours',
      icon: '🔥',
      color: Colors.orange,
    ),
    Achievement(
      id: 'streak_7',
      title: 'Semaine Parfaite',
      description: 'Complète toutes les quêtes pendant 7 jours',
      icon: '👑',
      color: Colors.purple,
    ),
    Achievement(
      id: 'level_5',
      title: 'Niveau 5',
      description: 'Atteins le niveau 5',
      icon: '⭐',
      color: Colors.yellow,
    ),
    Achievement(
      id: 'completionist',
      title: 'Perfectionniste',
      description: 'Complète 100 quêtes',
      icon: '🏆',
      color: QuestConstants.primaryGold,
    ),
  ];

  void checkAchievements({
    required int totalCompleted,
    required int currentStreak,
    required int level,
  }) {
    final now = DateTime.now();
    bool hasNewAchievement = false;

    state = state.map((achievement) {
      if (achievement.isUnlocked) return achievement;

      bool shouldUnlock = false;

      switch (achievement.id) {
        case 'first_quest':
          shouldUnlock = totalCompleted >= 1;
          break;
        case 'streak_3':
          shouldUnlock = currentStreak >= 3;
          break;
        case 'streak_7':
          shouldUnlock = currentStreak >= 7;
          break;
        case 'level_5':
          shouldUnlock = level >= 5;
          break;
        case 'completionist':
          shouldUnlock = totalCompleted >= 100;
          break;
      }

      if (shouldUnlock) {
        hasNewAchievement = true;
        return achievement.copyWith(
          isUnlocked: true,
          unlockedAt: now,
        );
      }

      return achievement;
    }).toList();

    if (hasNewAchievement) {
      _notifyNewAchievements();
    }
  }

  void _notifyNewAchievements() {
    // Cette méthode sera appelée par le provider principal
    // pour afficher les nouvelles réalisations
  }

  List<Achievement> get unlockedAchievements =>
      state.where((a) => a.isUnlocked).toList();

  List<Achievement> get lockedAchievements =>
      state.where((a) => !a.isUnlocked).toList();
}

final achievementProvider = StateNotifierProvider<AchievementService, List<Achievement>>((ref) {
  return AchievementService();
});