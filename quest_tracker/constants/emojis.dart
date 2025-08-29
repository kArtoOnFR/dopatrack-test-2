import 'package:flutter/material.dart';

class QuestEmoji {
  final String emoji;
  final Color color;

  const QuestEmoji(this.emoji, this.color);
}

const questEmojis = <QuestEmoji>[
  QuestEmoji('😊', Color(0xFFA5D6A7)), // vert clair
  QuestEmoji('😐', Color(0xFFFFF59D)), // jaune pâle
  QuestEmoji('😢', Color(0xFF81D4FA)), // bleu clair
  QuestEmoji('😡', Color(0xFFEF9A9A)), // rouge clair
];
