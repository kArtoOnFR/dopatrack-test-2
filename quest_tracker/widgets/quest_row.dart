import 'package:flutter/material.dart';
import '../models/quest_cell_id.dart';
import 'quest_cell.dart';

class QuestRow extends StatelessWidget {
  final int rowIndex;
  final String title;
  final int? activeRow;
  final int? activeCol;
  final void Function(BuildContext cellContext, int colIndex) onTap;
  final List<DateTime> weekDates;

  const QuestRow({
    super.key,
    required this.rowIndex,
    required this.title,
    required this.activeRow,
    required this.activeCol,
    required this.onTap,
    required this.weekDates,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          height: 80,
          margin: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: List.generate(weekDates.length, (colIndex) {
              final id = QuestCellId(rowIndex, colIndex);
              final isActive = activeRow == rowIndex && activeCol == colIndex;
              final isToday = DateUtils.isSameDay(weekDates[colIndex], DateTime.now());

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                      border: isToday
                          ? Border.all(color: Colors.blueAccent, width: 2)
                          : null,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: QuestCell(
                      id: id,
                      isActive: isActive,
                      onTap: (ctx) => onTap(ctx, colIndex),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
