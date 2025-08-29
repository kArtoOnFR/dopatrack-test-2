// // lib/quest_tracker/screens/quest_week_view.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../models/quest_cell_id.dart';
// import '../providers/active_cell_provider.dart';
// import '../providers/quest_matrix_provider.dart';
// import '../widgets/emoji_menu.dart';
// import '../widgets/quest_cell.dart';
// import '../widgets/quest_duration_slider.dart';
// import '../widgets/week_footer.dart';
// import '../widgets/week_header.dart';
//
// enum DockAction { none, emoji, duration }
//
// // --- WIDGET PRINCIPAL ---
// class QuestWeekView extends ConsumerStatefulWidget {
//   final List<DateTime> weekDates;
//   const QuestWeekView({super.key, required this.weekDates});
//
//   @override
//   ConsumerState<QuestWeekView> createState() => _QuestWeekViewState();
// }
//
// class _QuestWeekViewState extends ConsumerState<QuestWeekView> {
//   final List<String> _quests = List.generate(10, (i) => 'Quête ${i + 1}');
//   OverlayEntry? _overlayEntry;
//   DockAction _currentAction = DockAction.emoji;
//
//   void _removeOverlay() {
//     ref.read(activeCellProvider.notifier).state = null;
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   }
//
//   void _showOverlay(BuildContext cellContext, QuestCellId id) {
//     if (_overlayEntry != null) _removeOverlay();
//
//     ref.read(activeCellProvider.notifier).state = id;
//     setState(() => _currentAction = DockAction.emoji);
//
//     final RenderBox cellBox = cellContext.findRenderObject() as RenderBox;
//     final Rect cellRect = cellBox.localToGlobal(Offset.zero) & cellBox.size;
//     final screenSize = MediaQuery.of(context).size;
//
//     _overlayEntry = OverlayEntry(
//       builder: (context) {
//         final showDockAbove = cellRect.center.dy > screenSize.height / 2;
//         final showMenuOnRight = cellRect.center.dx < screenSize.width / 2;
//
//         return Stack(
//           children: [
//             Positioned.fill(
//               child: GestureDetector(
//                 onTap: _removeOverlay,
//                 child: Container(color: Colors.black.withOpacity(0.6)),
//               ),
//             ),
//             Positioned(
//               left: showMenuOnRight ? cellRect.left : null,
//               right: !showMenuOnRight ? screenSize.width - cellRect.right : null,
//               top: showDockAbove ? null : cellRect.bottom + 10,
//               bottom: showDockAbove ? screenSize.height - cellRect.top + 10 : null,
//               child: _DockAndMenuSystem(
//                 activeCellId: id,
//                 onClose: _removeOverlay,
//                 onActionChange: (action) => setState(() => _currentAction = action),
//                 currentAction: _currentAction,
//                 showOnRight: showMenuOnRight,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//
//     Overlay.of(context).insert(_overlayEntry!);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final activeId = ref.watch(activeCellProvider);
//     return Column(
//       children: [
//         WeekHeader(dates: widget.weekDates),
//         Expanded(
//           child: NotificationListener<ScrollNotification>(
//             onNotification: (_) {
//               if (_overlayEntry != null) _removeOverlay();
//               return false;
//             },
//             child: ListView.builder(
//               itemCount: _quests.length,
//               itemBuilder: (context, rowIndex) => _buildQuestRow(rowIndex, activeId),
//             ),
//           ),
//         ),
//         WeekFooter(weekDates: widget.weekDates, totalQuests: _quests.length),
//       ],
//     );
//   }
//
//   Widget _buildQuestRow(int rowIndex, QuestCellId? activeId) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           child: Text(_quests[rowIndex], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
//         ),
//         SizedBox(
//           height: 80,
//           child: Row(
//             children: List.generate(widget.weekDates.length, (colIndex) {
//               final id = QuestCellId(rowIndex, colIndex);
//               final isToday = DateUtils.isSameDay(widget.weekDates[colIndex], DateTime.now());
//               final isActive = id == activeId;
//
//               return Expanded(
//                 child: Builder(builder: (cellContext) {
//                   return Padding(
//                     padding: const EdgeInsets.all(2),
//                     child: DecoratedBox(
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: isToday ? Colors.blueAccent : Colors.transparent,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: QuestCell(
//                         id: id,
//                         isActive: isActive,
//                         onTap: (_) => _showOverlay(cellContext, id),
//                       ),
//                     ),
//                   );
//                 }),
//               );
//             }),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _DockAndMenuSystem extends ConsumerWidget {
//   final QuestCellId activeCellId;
//   final VoidCallback onClose;
//   final DockAction currentAction;
//   final ValueChanged<DockAction> onActionChange;
//   final bool showOnRight;
//
//   const _DockAndMenuSystem({
//     required this.activeCellId,
//     required this.onClose,
//     required this.currentAction,
//     required this.onActionChange,
//     required this.showOnRight,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final dock = _buildDock(ref);
//     Widget menu = _buildMenu(ref);
//
//     return Material(
//       color: Colors.transparent,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: showOnRight
//             ? [dock, const SizedBox(width: 8), menu]
//             : [menu, const SizedBox(width: 8), dock],
//       ),
//     );
//   }
//
//   Widget _buildDock(WidgetRef ref) {
//     return Container(
//       padding: const EdgeInsets.all(6),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black38)],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _buildFab(ref, DockAction.emoji, Icons.emoji_emotions_outlined),
//           const SizedBox(height: 8),
//           _buildFab(ref, DockAction.duration, Icons.timer_outlined),
//           const SizedBox(height: 8),
//           _buildResetFab(ref),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFab(WidgetRef ref, DockAction action, IconData icon) {
//     final currentEmoji = ref.watch(questMatrixProvider.select((m) => m[activeCellId]?.emoji));
//     final child = (action == DockAction.emoji && currentEmoji != null)
//         ? Text(currentEmoji, style: const TextStyle(fontSize: 18))
//         : Icon(icon, size: 20, color: currentAction == action ? Colors.blue : Colors.black87);
//
//     return Material(
//       color: currentAction == action ? Colors.blue.shade50 : Colors.white,
//       elevation: 2,
//       shape: const CircleBorder(),
//       clipBehavior: Clip.antiAlias,
//       child: InkWell(
//         onTap: () => onActionChange(currentAction == action ? DockAction.none : action),
//         child: Padding(padding: const EdgeInsets.all(10), child: child),
//       ),
//     );
//   }
//
//   Widget _buildResetFab(WidgetRef ref) {
//     return Material(
//       color: Colors.white,
//       elevation: 2,
//       shape: const CircleBorder(),
//       clipBehavior: Clip.antiAlias,
//       child: InkWell(
//         onTap: () {
//           ref.read(questMatrixProvider.notifier).reset(activeCellId);
//           onClose();
//         },
//         child: const Padding(padding: const EdgeInsets.all(10), child: Icon(Icons.restart_alt, size: 20)),
//       ),
//     );
//   }
//
//   Widget _buildMenu(WidgetRef ref) {
//     Widget? menuContent;
//
//     if (currentAction == DockAction.emoji) {
//       menuContent = Material(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(22),
//         elevation: 4,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//           child: EmojiMenu(onSelected: (emoji) {
//             ref.read(questMatrixProvider.notifier).setEmoji(activeCellId, emoji);
//             onActionChange(DockAction.duration);
//           }),
//         ),
//       );
//     } else if (currentAction == DockAction.duration) {
//       final duration = ref.watch(questMatrixProvider.select((m) => m[activeCellId]?.duration));
//       menuContent = Material(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         elevation: 4,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           width: 220,
//           height: 50,
//           child: QuestDurationSlider(
//             initialValue: duration ?? 30,
//             onChanged: (v) => ref.read(questMatrixProvider.notifier).setDuration(activeCellId, v),
//             onSubmitted: (_) => onClose(),
//           ),
//         ),
//       );
//     }
//
//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 200),
//       transitionBuilder: (child, animation) => FadeTransition(
//         opacity: animation,
//         child: ScaleTransition(scale: animation, child: child),
//       ),
//       child: menuContent ?? const SizedBox(width: 220),
//     );
//   }
// }