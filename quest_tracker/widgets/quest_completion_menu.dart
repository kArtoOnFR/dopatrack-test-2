// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/quest_cell_id.dart';
// import '../providers/quest_matrix_provider.dart';
// import 'emoji_menu.dart';
// import 'quest_duration_slider.dart';
// import 'quest_reset_button.dart';
//
// class QuestCompletionMenu extends ConsumerWidget {
//   final QuestCellId id;
//   final double cellHeight;
//   final VoidCallback onClose;
//
//   const QuestCompletionMenu({
//     super.key,
//     required this.id,
//     required this.cellHeight,
//     required this.onClose,
//
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//
//     final duration = ref.watch(questMatrixProvider.select((m) => m[id]?.duration ?? 30));
//
//     return Material(
//       elevation: 8,
//       borderRadius: BorderRadius.circular(12),
//       color: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             QuestDurationSlider(
//               id: id,
//               height: cellHeight,
//               onClose: onClose
//             ),
//             const SizedBox(height: 8),
//             QuestResetButton(
//               id: id,
//               onClose: onClose,
//
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../models/quest_cell_id.dart';
import 'quest_duration_slider.dart';

class QuestCompletionMenu extends StatelessWidget {
  final QuestCellId id;
  final double cellHeight;
  final VoidCallback onClose;
  final bool showHeaderEmoji; // NEW (désactivable si tu as une barre emoji au-dessus)
  final String? currentEmoji;
  final double? currentDuration;
  final ValueChanged<double>? onDurationChanged;
  final ValueChanged<double>? onDurationSubmitted;

  const QuestCompletionMenu({
    super.key,
    required this.id,
    required this.cellHeight,
    required this.onClose,
    this.showHeaderEmoji = true,
    this.currentEmoji,
    this.currentDuration,
    this.onDurationChanged,
    this.onDurationSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: 6,
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showHeaderEmoji && currentEmoji != null) ...[
              CircleAvatar(
                radius: (cellHeight * 0.24).clamp(18, 26),
                backgroundColor: Colors.grey[100],
                child: Text(currentEmoji!, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 10),
            ],
            QuestDurationSlider(
              initialValue: (currentDuration ?? 30).toDouble(),
              onChanged: onDurationChanged,
              onSubmitted: onDurationSubmitted,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: onClose, child: const Text('Fermer')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
