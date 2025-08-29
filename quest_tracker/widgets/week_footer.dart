// lib/quest_tracker/widgets/week_footer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quest_cell_id.dart';
import '../providers/quest_matrix_provider.dart';
import '../providers/quest_matrix_provider_improved.dart';

class WeekFooter extends ConsumerWidget {
  final List<DateTime> weekDates;
  final int totalQuests;

  const WeekFooter({
    super.key,
    required this.weekDates,
    required this.totalQuests,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matrix = ref.watch(questMatrixProvider);

    return Container(
      height: 20,
      color: Colors.grey[200],
      child: Row(
        children: List.generate(weekDates.length, (colIndex) {
          final completedCount = List.generate(totalQuests, (row) {
            final id = QuestCellId(row, colIndex);
            final data = matrix[id];
            // Toute cellule initialisée compte comme complétée
            return data != null ? 1 : 0;
          }).fold(0, (a, b) => a + b);

          final completionRatio = completedCount / totalQuests;
          final fillColor = Color.lerp(Colors.transparent, Colors.green, completionRatio)!;

          return Expanded(
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
      ),
    );
  }
}
