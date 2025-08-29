import 'dart:math';

import 'package:flutter/material.dart';

import 'constants.dart';

class QuestAnimations {
  static Animation<double> createElasticAnimation(
      AnimationController controller, {
        double begin = 0.0,
        double end = 1.0,
      }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: controller,
        curve: QuestConstants.elasticCurve,
      ),
    );
  }

  static Animation<Offset> createSlideAnimation(
      AnimationController controller, {
        Offset begin = const Offset(0, 1),
        Offset end = Offset.zero,
      }) {
    return Tween<Offset>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: controller,
        curve: QuestConstants.smoothCurve,
      ),
    );
  }

  static Animation<double> createBounceAnimation(
      AnimationController controller,
      ) {
    return Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: QuestConstants.bounceCurve,
      ),
    );
  }

  // Animation de particules pour les récompenses
  static Widget createParticleExplosion({
    required Widget child,
    required bool trigger,
  }) {
    return AnimatedContainer(
      duration: QuestConstants.mediumAnimation,
      child: Stack(
        children: [
          child,
          if (trigger) ...[
            ...List.generate(8, (index) {
              final angle = (index * 45) * (3.14159 / 180);
              return AnimatedPositioned(
                duration: QuestConstants.slowAnimation,
                left: 50 + (30 * cos(angle)),
                top: 50 + (30 * sin(angle)),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}