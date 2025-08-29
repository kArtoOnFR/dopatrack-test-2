import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import '../models/quest_cell_id.dart';
import '../models/quest_data.dart';

class QuestMatrixNotifierImproved extends StateNotifier<Map<QuestCellId, QuestData>> {
  QuestMatrixNotifierImproved() : super({});

  // Cache pour éviter les recalculs
  final Map<String, dynamic> _cache = {};

  // Noms des quêtes
  final List<String> _questNames = [
    '🏃‍♂️ Course matinale',
    '📚 Lecture quotidienne',
    '🧘‍♀️ Méditation',
    '💧 Hydratation',
    '🥗 Alimentation saine',
    '💤 Sommeil optimal',
    '📱 Digital detox',
    '🎨 Créativité',
    '🤝 Connexion sociale',
    '📝 Journal personnel',
  ];

  int get questCount => _questNames.length;

  String getQuestName(int index) {
    if (index < 0 || index >= _questNames.length) {
      return 'Quête inconnue';
    }
    return _questNames[index];
  }

  void setEmoji(QuestCellId id, String emoji) {
    _invalidateCache();
    final current = state[id] ?? const QuestData();
    state = {
      ...state,
      id: current.copyWith(emoji: emoji),
    };
  }

  void setDuration(QuestCellId id, double duration) {
    _invalidateCache();
    final current = state[id] ?? const QuestData();
    state = {
      ...state,
      id: current.copyWith(duration: duration),
    };
  }

  void setNotes(QuestCellId id, String notes) {
    _invalidateCache();
    final current = state[id] ?? const QuestData();
    state = {
      ...state,
      id: current.copyWith(notes: notes.isEmpty ? null : notes),
    };
  }

  void toggleComplete(QuestCellId id) {
    _invalidateCache();
    final current = state[id] ?? const QuestData();
    final isCompleting = !current.isCompleted;

    int newStreak = current.streak;
    if (isCompleting) {
      newStreak = _calculateNewStreak(id);
    } else {
      newStreak = 0;
    }

    state = {
      ...state,
      id: current.copyWith(
        isCompleted: isCompleting,
        completedAt: isCompleting ? DateTime.now() : null,
        streak: newStreak,
      ),
    };

    // Notifier le système de gamification
    if (isCompleting) {
      _notifyQuestCompleted(state[id]!);
    }
  }

  void reset(QuestCellId id) {
    _invalidateCache();
    state = {
      ...state,
      id: const QuestData(),
    };
  }

  int _calculateNewStreak(QuestCellId id) {
    // Calculer la série basée sur les jours précédents
    final currentRow = id.row;
    final currentCol = id.col;

    int streak = 1;

    // Vérifier les jours précédents
    for (int col = currentCol - 1; col >= 0; col--) {
      final prevId = QuestCellId(currentRow, col);
      final prevData = state[prevId];

      if (prevData?.isCompleted == true) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  void _notifyQuestCompleted(QuestData questData) {
    // Cette méthode sera appelée par un listener du provider principal
    // pour mettre à jour les statistiques de gamification
  }

  void _invalidateCache() {
    _cache.clear();
  }

  // Méthodes de cache pour les calculs coûteux
  double getQuestCompletionRate(int questIndex, int weekLength) {
    final cacheKey = 'completion_rate_${questIndex}_$weekLength';

    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey] as double;
    }

    int completed = 0;
    for (int col = 0; col < weekLength; col++) {
      final id = QuestCellId(questIndex, col);
      if (state[id]?.isCompleted == true) {
        completed++;
      }
    }

    final rate = completed / weekLength;
    _cache[cacheKey] = rate;
    return rate;
  }

  Map<String, int> getWeeklyStats(int weekLength) {
    const cacheKey = 'weekly_stats';

    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey] as Map<String, int>;
    }

    int totalCompleted = 0;
    int totalPossible = questCount * weekLength;
    int longestStreak = 0;

    for (int row = 0; row < questCount; row++) {
      for (int col = 0; col < weekLength; col++) {
        final id = QuestCellId(row, col);
        final data = state[id];

        if (data?.isCompleted == true) {
          totalCompleted++;
          if (data!.streak > longestStreak) {
            longestStreak = data.streak;
          }
        }
      }
    }

    final stats = {
      'completed': totalCompleted,
      'possible': totalPossible,
      'percentage': ((totalCompleted / totalPossible) * 100).round(),
      'longest_streak': longestStreak,
    };

    _cache[cacheKey] = stats;
    return stats;
  }

  List<QuestCellId> getTodayQuests(DateTime today, List<DateTime> weekDates) {
    final todayIndex = weekDates.indexWhere((date) =>
        DateUtils.isSameDay(date, today)
    );

    if (todayIndex == -1) return [];

    return List.generate(questCount, (row) => QuestCellId(row, todayIndex));
  }

  // Export/Import pour la persistence (bonus)
  Map<String, dynamic> exportData() {
    return {
      'quest_data': state.map((key, value) => MapEntry(
        '${key.row}_${key.col}',
        {
          'emoji': value.emoji,
          'duration': value.duration,
          'streak': value.streak,
          'notes': value.notes,
          'isCompleted': value.isCompleted,
          'completedAt': value.completedAt?.toIso8601String(),
          'xpReward': value.xpReward,
          'difficulty': value.difficulty.name,
        },
      )),
      'quest_names': _questNames,
      'version': '1.0',
    };
  }

  void importData(Map<String, dynamic> data) {
    if (data['version'] != '1.0') return;

    _invalidateCache();

    final questData = data['quest_data'] as Map<String, dynamic>;
    final newState = <QuestCellId, QuestData>{};

    questData.forEach((key, value) {
      final parts = key.split('_');
      if (parts.length == 2) {
        final row = int.tryParse(parts[0]);
        final col = int.tryParse(parts[1]);

        if (row != null && col != null) {
          final id = QuestCellId(row, col);
          final valueMap = value as Map<String, dynamic>;

          newState[id] = QuestData(
            emoji: valueMap['emoji'],
            duration: valueMap['duration']?.toDouble(),
            streak: valueMap['streak'] ?? 0,
            notes: valueMap['notes'],
            isCompleted: valueMap['isCompleted'] ?? false,
            completedAt: valueMap['completedAt'] != null
                ? DateTime.parse(valueMap['completedAt'])
                : null,
            xpReward: valueMap['xpReward'] ?? 10,
            difficulty: QuestDifficulty.values.firstWhereOrNull(
                    (d) => d.name == valueMap['difficulty']
            ) ?? QuestDifficulty.normal,
          );
        }
      }
    });

    state = newState;
  }
}

final questMatrixProvider =
StateNotifierProvider<QuestMatrixNotifierImproved, Map<QuestCellId, QuestData>>(
      (ref) => QuestMatrixNotifierImproved(),
);