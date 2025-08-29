// // lib/quest_tracker/providers/quest_matrix_provider.dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/quest_cell_data.dart';
// import '../models/quest_cell_id.dart';
//
// class QuestMatrixNotifier extends StateNotifier<Map<QuestCellId, QuestCellData>> {
//   QuestMatrixNotifier() : super({});
//
//   // void setEmoji(QuestCellId id, String emoji) {
//   //   final old = state[id];
//   //   state = {
//   //     ...state,
//   //     id: QuestCellData(emoji: emoji, duration: old?.duration)
//   //   };
//   // }
//   //
//   // void setDuration(QuestCellId id, double duration) {
//   //   final old = state[id];
//   //   state = {
//   //     ...state,
//   //     id: QuestCellData(emoji: old?.emoji, duration: duration)
//   //   };
//   // }
//
//   void setEmoji(QuestCellId id, String emoji) {
//     final current = state[id] ?? const QuestCellData();
//     state = {...state, id: current.copyWith(emoji: emoji)};
//   }
//
//   void setDuration(QuestCellId id, double duration) {
//     final current = state[id] ?? const QuestCellData();
//     state = {...state, id: current.copyWith(duration: duration)};
//   }
//
//   void clear(QuestCellId id) {
//     state = {...state}..remove(id);
//   }
//
//   void setRaw(QuestCellId id) {
//     state = {
//       ...state,
//       id: const QuestCellData(),
//     };
//   }
//
//   // hypothèse :
// // - state est un Map<QuestCellId, QuestCellData>
// // - QuestCellId et QuestCellData sont déjà définis chez toi
// // - ce code est à mettre dans la classe Notifier / StateNotifier qui gère `questMatrixProvider`
//
//   void reset(QuestCellId id) {
//     // on retire l'entrée => l'UI verra "cellule non complétée"
//     final next = Map<QuestCellId, QuestCellData>.from(state);
//     next.remove(id);
//     state = next;
//   }
//
//
//
// }
//
// final questMatrixProvider = StateNotifierProvider<QuestMatrixNotifier, Map<QuestCellId, QuestCellData>>(
//       (ref) => QuestMatrixNotifier(),
// );
