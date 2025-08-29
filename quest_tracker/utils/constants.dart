import 'package:flutter/material.dart';

import '../models/quest_data.dart';

class QuestConstants {
  // Animations
  static const Duration fastAnimation = Duration(milliseconds: 150);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 600);
  static const Duration staggerDelay = Duration(milliseconds: 80);

  // Courbes d'animation
  static const Curve elasticCurve = Curves.elasticOut;
  static const Curve bounceCurve = Curves.bounceOut;
  static const Curve smoothCurve = Curves.easeInOutCubic;

  // Dimensions
  static const double cellHeight = 80.0;
  static const double dockRadius = 28.0;
  static const double fabSize = 48.0;
  static const double menuWidth = 280.0;

  // Couleurs
  static const Color primaryGold = Color(0xFFFFD700);
  static const Color secondaryBlue = Color(0xFF4A90E2);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFF44336);

  // Gradients
  static const LinearGradient questGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF667eea),
      Color(0xFF764ba2),
    ],
  );

  static const LinearGradient completedGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF11998e),
      Color(0xFF38ef7d),
    ],
  );

  static const LinearGradient levelGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFf093fb),
      Color(0xFFf5576c),
    ],
  );

  // Système XP
  static const int baseXP = 10;
  static const int streakBonus = 5;
  static const int perfectWeekBonus = 50;

  // Niveaux de difficulté
  static const Map<QuestDifficulty, int> difficultyXP = {
    QuestDifficulty.easy: 10,
    QuestDifficulty.normal: 15,
    QuestDifficulty.hard: 25,
    QuestDifficulty.epic: 40,
  };
}
