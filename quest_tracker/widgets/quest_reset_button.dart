// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/quest_cell_id.dart';
// import '../providers/quest_matrix_provider.dart';
//
// class QuestResetButton extends ConsumerWidget {
//   final QuestCellId id;
//   final VoidCallback onClose;
//
//   const QuestResetButton({super.key, required this.id,required this.onClose});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return TextButton.icon(
//       onPressed: () {
//         ref.read(questMatrixProvider.notifier).clear(id);
//         onClose();
//       },
//       icon: const Icon(Icons.delete_outline),
//       label: const Text("Réinitialiser"),
//     );
//   }
// }


import 'package:flutter/material.dart';

class QuestResetButton extends StatelessWidget {
  final VoidCallback onConfirm;

  const QuestResetButton({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () async {
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Réinitialiser ?'),
            content: const Text('Cela supprimera l’emoji et la durée.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
              FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Oui')),
            ],
          ),
        );
        if (ok == true) onConfirm();
      },
      icon: const Icon(Icons.restart_alt),
      label: const Text('Réinitialiser'),
    );
  }
}
