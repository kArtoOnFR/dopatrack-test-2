import 'package:flutter/material.dart';

class QuestData {
  final String? emoji;
  final double? duration;
  final int streak;
  final String? notes;
  final bool isCompleted;
  final DateTime? completedAt;
  final int xpReward;
  final QuestDifficulty difficulty;

  const QuestData({
    this.emoji,
    this.duration,
    this.streak = 0,
    this.notes,
    this.isCompleted = false,
    this.completedAt,
    this.xpReward = 10,
    this.difficulty = QuestDifficulty.normal,
  });

  QuestData copyWith({
    String? emoji,
    double? duration,
    int? streak,
    String? notes,
    bool? isCompleted,
    DateTime? completedAt,
    int? xpReward,
    QuestDifficulty? difficulty,
  }) {
    return QuestData(
      emoji: emoji ?? this.emoji,
      duration: duration ?? this.duration,
      streak: streak ?? this.streak,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      xpReward: xpReward ?? this.xpReward,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}

enum QuestDifficulty {
  easy(multiplier: 1.0, color: Colors.green),
  normal(multiplier: 1.5, color: Colors.blue),
  hard(multiplier: 2.0, color: Colors.orange),
  epic(multiplier: 3.0, color: Colors.purple);

  const QuestDifficulty({
    required this.multiplier,
    required this.color,
  });

  final double multiplier;
  final Color color;
}