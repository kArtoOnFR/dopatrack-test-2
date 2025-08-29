// import 'package:dopatrack/quest_tracker/widgets/quest_cell_visual.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../models/quest_cell_id.dart';
// import '../providers/quest_matrix_provider.dart';
//
// class QuestCell extends ConsumerWidget {
//   final QuestCellId id;
//   final bool isActive;
//   final void Function(BuildContext cellContext) onTap;
//
//   const QuestCell({
//     super.key,
//     required this.id,
//     required this.isActive,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Builder(
//       builder: (cellContext) {
//         return GestureDetector(
//           onTap: () {
//             final cellData = ref.read(questMatrixProvider)[id];
//             if (cellData == null) {
//               ref.read(questMatrixProvider.notifier).setRaw(id);
//             }
//             onTap(cellContext);
//           },
//           child: QuestCellVisual(id: id, isActive: isActive),
//         );
//       },
//     );
//   }
// }
// lib/quest_tracker/widgets/quest_cell.dart
import 'package:dopatrack/quest_tracker/widgets/quest_cell_visual.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quest_cell_id.dart';
import '../providers/quest_matrix_provider.dart';
import '../providers/quest_matrix_provider_improved.dart';

class QuestCell extends ConsumerWidget {
  final QuestCellId id;
  final bool isActive;
  final void Function(BuildContext cellContext) onTap;
  final Widget? child; // Optionnel, pour le CompositedTransformTarget

  const QuestCell({
    super.key,
    required this.id,
    required this.isActive,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Builder(
      builder: (cellContext) {
        return GestureDetector(
          onTap: () {
            final cellData = ref.read(questMatrixProvider)[id];
            if (cellData == null) {
              // ref.read(questMatrixProvider.notifier).setRaw(id);
            }
            onTap(cellContext);
          },
          // Le child est utilisé pour le QuestCellVisual
          child: child ?? QuestCellVisual(id: id, isActive: isActive),
        );
      },
    );
  }
}