import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quest_cell_id.dart';
import '../providers/quest_matrix_provider.dart';
import '../constants/emojis.dart';
import '../providers/quest_matrix_provider_improved.dart';

class QuestCellVisual extends ConsumerWidget {
  final QuestCellId id;
  final bool isActive;
  final bool animated;

  const QuestCellVisual({
    super.key,
    required this.id,
    required this.isActive,
    this.animated = true, // <-- animation activée par défaut
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cellData = ref.watch(questMatrixProvider.select((map) => map[id]));
    final emoji = cellData?.emoji;
    final duration = cellData?.duration;
    final isCompleted = cellData != null;

    final color = emoji != null
        ? questEmojis.firstWhere(
          (e) => e.emoji == emoji,
      orElse: () => const QuestEmoji('', Colors.grey),
    ).color
        : (isCompleted ? Colors.purple.shade100 : Colors.grey.shade300);

    String? formatDuration(double? minutes) {
      if (minutes == null) return null;
      final int mins = minutes.round();
      if (mins < 60) return '$mins min';
      final int hours = mins ~/ 60;
      final int rest = mins % 60;
      return rest == 0 ? '$hours h' : '$hours h $rest';
    }

    final Widget content = Stack(
      children: [
        // Emoji centré
        Center(
          child: emoji != null
              ? Text(
            emoji,
            key: ValueKey('emoji-$emoji'),
            style: const TextStyle(fontSize: 20),
          )
              : const SizedBox.shrink(),
        ),
        // Durée en bas
        if (duration != null)
          Positioned(
            bottom: 4,
            left: 0,
            right: 0,
            child: Text(
              formatDuration(duration)!,
              key: ValueKey('duration-${duration.round()}'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Colors.black87),
            ),
          ),
        // ✅ par défaut
        if (emoji == null && duration == null)
          const Center(
            child: Icon(Icons.check, key: ValueKey('check')),
          ),
      ],
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: animated
          ? AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, anim) =>
            ScaleTransition(scale: anim, child: child),
        child: content,
      )
          : content,
    );
  }


}