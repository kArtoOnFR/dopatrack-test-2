import 'package:flutter/material.dart';

import '../models/achievement.dart';
import 'achievement_popup.dart';

class GamificationOverlay extends StatefulWidget {
  final Widget child;

  const GamificationOverlay({
    super.key,
    required this.child,
  });

  @override
  State<GamificationOverlay> createState() => _GamificationOverlayState();
}

class _GamificationOverlayState extends State<GamificationOverlay> {
  final List<AchievementPopup> _activePopups = [];

  void _showAchievement(Achievement achievement) {
    setState(() {
      _activePopups.add(
        AchievementPopup(
          title: achievement.title,
          description: achievement.description,
          icon: achievement.icon,
          color: achievement.color,
          onDismiss: () {
            setState(() {
              _activePopups.removeWhere((popup) =>
              popup.title == achievement.title
              );
            });
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,

        // Overlay pour les réalisations
        ...List.generate(_activePopups.length, (index) {
          return Positioned(
            top: 100 + (index * 100.0),
            left: 0,
            right: 0,
            child: _activePopups[index],
          );
        }),
      ],
    );
  }
}