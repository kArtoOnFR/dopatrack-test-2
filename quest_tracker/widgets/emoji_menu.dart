// lib/quest_tracker/widgets/emoji_menu.dart
import 'package:dopatrack/quest_tracker/constants/emojis.dart';
import 'package:flutter/material.dart';

/// Une barre horizontale d'emojis sélectionnables, sans fond propre.
class EmojiMenu extends StatelessWidget {
  final void Function(String emoji) onSelected;

  const EmojiMenu({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final emojis = questEmojis.map((e) => e.emoji).toList();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final e in emojis)
          Padding(
            // Espacement réduit
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: InkWell(
              onTap: () => onSelected(e),
              borderRadius: BorderRadius.circular(20),
              child: CircleAvatar(
                // Rayon réduit pour des emojis plus petits
                radius: 18,
                backgroundColor: Colors.grey[100],
                child: Text(e, style: const TextStyle(fontSize: 20)),
              ),
            ),
          ),
      ],
    );
  }
}