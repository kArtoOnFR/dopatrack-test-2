// // lib/quest_tracker/providers/quest_matrix_provider_improved.dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:collection/collection.dart';
//
// class QuestMatrixNotifierImproved extends StateNotifier<Map<QuestCellId, QuestData>> {
//   QuestMatrixNotifierImproved() : super({});
//
//   // Cache pour éviter les recalculs
//   final Map<String, dynamic> _cache = {};
//
//   // Noms des quêtes
//   final List<String> _questNames = [
//     '🏃‍♂️ Course matinale',
//     '📚 Lecture quotidienne',
//     '🧘‍♀️ Méditation',
//     '💧 Hydratation',
//     '🥗 Alimentation saine',
//     '💤 Sommeil optimal',
//     '📱 Digital detox',
//     '🎨 Créativité',
//     '🤝 Connexion sociale',
//     '📝 Journal personnel',
//   ];
//
//   int get questCount => _questNames.length;
//
//   String getQuestName(int index) {
//     if (index < 0 || index >= _questNames.length) {
//       return 'Quête inconnue';
//     }
//     return _questNames[index];
//   }
//
//   void setEmoji(QuestCellId id, String emoji) {
//     _invalidateCache();
//     final current = state[id] ?? const QuestData();
//     state = {
//       ...state,
//       id: current.copyWith(emoji: emoji),
//     };
//   }
//
//   void setDuration(QuestCellId id, double duration) {
//     _invalidateCache();
//     final current = state[id] ?? const QuestData();
//     state = {
//       ...state,
//       id: current.copyWith(duration: duration),
//     };
//   }
//
//   void setNotes(QuestCellId id, String notes) {
//     _invalidateCache();
//     final current = state[id] ?? const QuestData();
//     state = {
//       ...state,
//       id: current.copyWith(notes: notes.isEmpty ? null : notes),
//     };
//   }
//
//   void toggleComplete(QuestCellId id) {
//     _invalidateCache();
//     final current = state[id] ?? const QuestData();
//     final isCompleting = !current.isCompleted;
//
//     int newStreak = current.streak;
//     if (isCompleting) {
//       newStreak = _calculateNewStreak(id);
//     } else {
//       newStreak = 0;
//     }
//
//     state = {
//       ...state,
//       id: current.copyWith(
//         isCompleted: isCompleting,
//         completedAt: isCompleting ? DateTime.now() : null,
//         streak: newStreak,
//       ),
//     };
//
//     // Notifier le système de gamification
//     if (isCompleting) {
//       _notifyQuestCompleted(state[id]!);
//     }
//   }
//
//   void reset(QuestCellId id) {
//     _invalidateCache();
//     state = {
//       ...state,
//       id: const QuestData(),
//     };
//   }
//
//   int _calculateNewStreak(QuestCellId id) {
//     // Calculer la série basée sur les jours précédents
//     final currentRow = id.row;
//     final currentCol = id.col;
//
//     int streak = 1;
//
//     // Vérifier les jours précédents
//     for (int col = currentCol - 1; col >= 0; col--) {
//       final prevId = QuestCellId(currentRow, col);
//       final prevData = state[prevId];
//
//       if (prevData?.isCompleted == true) {
//         streak++;
//       } else {
//         break;
//       }
//     }
//
//     return streak;
//   }
//
//   void _notifyQuestCompleted(QuestData questData) {
//     // Cette méthode sera appelée par un listener du provider principal
//     // pour mettre à jour les statistiques de gamification
//   }
//
//   void _invalidateCache() {
//     _cache.clear();
//   }
//
//   // Méthodes de cache pour les calculs coûteux
//   double getQuestCompletionRate(int questIndex, int weekLength) {
//     final cacheKey = 'completion_rate_${questIndex}_$weekLength';
//
//     if (_cache.containsKey(cacheKey)) {
//       return _cache[cacheKey] as double;
//     }
//
//     int completed = 0;
//     for (int col = 0; col < weekLength; col++) {
//       final id = QuestCellId(questIndex, col);
//       if (state[id]?.isCompleted == true) {
//         completed++;
//       }
//     }
//
//     final rate = completed / weekLength;
//     _cache[cacheKey] = rate;
//     return rate;
//   }
//
//   Map<String, int> getWeeklyStats(int weekLength) {
//     const cacheKey = 'weekly_stats';
//
//     if (_cache.containsKey(cacheKey)) {
//       return _cache[cacheKey] as Map<String, int>;
//     }
//
//     int totalCompleted = 0;
//     int totalPossible = questCount * weekLength;
//     int longestStreak = 0;
//
//     for (int row = 0; row < questCount; row++) {
//       for (int col = 0; col < weekLength; col++) {
//         final id = QuestCellId(row, col);
//         final data = state[id];
//
//         if (data?.isCompleted == true) {
//           totalCompleted++;
//           if (data!.streak > longestStreak) {
//             longestStreak = data.streak;
//           }
//         }
//       }
//     }
//
//     final stats = {
//       'completed': totalCompleted,
//       'possible': totalPossible,
//       'percentage': ((totalCompleted / totalPossible) * 100).round(),
//       'longest_streak': longestStreak,
//     };
//
//     _cache[cacheKey] = stats;
//     return stats;
//   }
//
//   List<QuestCellId> getTodayQuests(DateTime today, List<DateTime> weekDates) {
//     final todayIndex = weekDates.indexWhere((date) =>
//         DateUtils.isSameDay(date, today)
//     );
//
//     if (todayIndex == -1) return [];
//
//     return List.generate(questCount, (row) => QuestCellId(row, todayIndex));
//   }
//
//   // Export/Import pour la persistence (bonus)
//   Map<String, dynamic> exportData() {
//     return {
//       'quest_data': state.map((key, value) => MapEntry(
//         '${key.row}_${key.col}',
//         {
//           'emoji': value.emoji,
//           'duration': value.duration,
//           'streak': value.streak,
//           'notes': value.notes,
//           'isCompleted': value.isCompleted,
//           'completedAt': value.completedAt?.toIso8601String(),
//           'xpReward': value.xpReward,
//           'difficulty': value.difficulty.name,
//         },
//       )),
//       'quest_names': _questNames,
//       'version': '1.0',
//     };
//   }
//
//   void importData(Map<String, dynamic> data) {
//     if (data['version'] != '1.0') return;
//
//     _invalidateCache();
//
//     final questData = data['quest_data'] as Map<String, dynamic>;
//     final newState = <QuestCellId, QuestData>{};
//
//     questData.forEach((key, value) {
//       final parts = key.split('_');
//       if (parts.length == 2) {
//         final row = int.tryParse(parts[0]);
//         final col = int.tryParse(parts[1]);
//
//         if (row != null && col != null) {
//           final id = QuestCellId(row, col);
//           final valueMap = value as Map<String, dynamic>;
//
//           newState[id] = QuestData(
//             emoji: valueMap['emoji'],
//             duration: valueMap['duration']?.toDouble(),
//             streak: valueMap['streak'] ?? 0,
//             notes: valueMap['notes'],
//             isCompleted: valueMap['isCompleted'] ?? false,
//             completedAt: valueMap['completedAt'] != null
//                 ? DateTime.parse(valueMap['completedAt'])
//                 : null,
//             xpReward: valueMap['xpReward'] ?? 10,
//             difficulty: QuestDifficulty.values.firstWhereOrNull(
//                     (d) => d.name == valueMap['difficulty']
//             ) ?? QuestDifficulty.normal,
//           );
//         }
//       }
//     });
//
//     state = newState;
//   }
// }
//
// // lib/quest_tracker/widgets/performance_optimized_grid.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class PerformanceOptimizedGrid extends ConsumerWidget {
//   final List<DateTime> weekDates;
//   final QuestCellId? activeId;
//   final Function(QuestCellId) onCellTap;
//   final Function(QuestCellId?) onCellHover;
//
//   const PerformanceOptimizedGrid({
//     super.key,
//     required this.weekDates,
//     this.activeId,
//     required this.onCellTap,
//     required this.onCellHover,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final questMatrix = ref.watch(questMatrixProvider);
//     final questCount = ref.read(questMatrixProvider.notifier).questCount;
//
//     return CustomScrollView(
//       physics: const BouncingScrollPhysics(),
//       slivers: [
//         SliverList.builder(
//           itemCount: questCount,
//           itemBuilder: (context, rowIndex) {
//             return RepaintBoundary(
//               child: _QuestRowOptimized(
//                 rowIndex: rowIndex,
//                 weekDates: weekDates,
//                 activeId: activeId,
//                 questMatrix: questMatrix,
//                 onCellTap: onCellTap,
//                 onCellHover: onCellHover,
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
//
// class _QuestRowOptimized extends ConsumerWidget {
//   final int rowIndex;
//   final List<DateTime> weekDates;
//   final QuestCellId? activeId;
//   final Map<QuestCellId, QuestData> questMatrix;
//   final Function(QuestCellId) onCellTap;
//   final Function(QuestCellId?) onCellHover;
//
//   const _QuestRowOptimized({
//     required this.rowIndex,
//     required this.weekDates,
//     this.activeId,
//     required this.questMatrix,
//     required this.onCellTap,
//     required this.onCellHover,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final questName = ref.read(questMatrixProvider.notifier).getQuestName(rowIndex);
//     final completionRate = ref.read(questMatrixProvider.notifier)
//         .getQuestCompletionRate(rowIndex, weekDates.length);
//
//     return AnimatedContainer(
//       duration: QuestConstants.fastAnimation,
//       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _QuestHeader(
//             questName: questName,
//             completionRate: completionRate,
//           ),
//           SizedBox(
//             height: QuestConstants.cellHeight,
//             child: Row(
//               children: List.generate(weekDates.length, (colIndex) {
//                 final id = QuestCellId(rowIndex, colIndex);
//                 return Expanded(
//                   child: _OptimizedQuestCell(
//                     id: id,
//                     isToday: DateUtils.isSameDay(weekDates[colIndex], DateTime.now()),
//                     isActive: id == activeId,
//                     questData: questMatrix[id],
//                     onTap: onCellTap,
//                     onHover: onCellHover,
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _QuestHeader extends StatelessWidget {
//   final String questName;
//   final double completionRate;
//
//   const _QuestHeader({
//     required this.questName,
//     required this.completionRate,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final level = (completionRate * 10).floor() + 1;
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       child: Row(
//         children: [
//           // Icône de niveau avec animation
//           TweenAnimationBuilder<double>(
//             tween: Tween(begin: 0, end: completionRate),
//             duration: QuestConstants.mediumAnimation,
//             builder: (context, value, child) {
//               return Container(
//                 width: 24,
//                 height: 24,
//                 decoration: BoxDecoration(
//                   color: _getLevelColor(level),
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: _getLevelColor(level).withOpacity(0.3),
//                       blurRadius: 4 * value,
//                       spreadRadius: 1 * value,
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Text(
//                     level.toString(),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//           const SizedBox(width: 8),
//
//           // Nom de la quête
//           Expanded(
//             child: Text(
//               questName,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//
//           // Barre de progression animée
//           TweenAnimationBuilder<double>(
//             tween: Tween(begin: 0, end: completionRate),
//             duration: QuestConstants.mediumAnimation,
//             curve: Curves.easeOutQuart,
//             builder: (context, value, child) {
//               return Container(
//                 width: 60,
//                 height: 8,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Stack(
//                   children: [
//                     Container(
//                       width: 60 * value,
//                       decoration: BoxDecoration(
//                         gradient: QuestConstants.levelGradient,
//                         borderRadius: BorderRadius.circular(4),
//                         boxShadow: value > 0.5 ? [
//                           BoxShadow(
//                             color: Colors.purple.withOpacity(0.3),
//                             blurRadius: 4,
//                           ),
//                         ] : null,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Color _getLevelColor(int level) {
//     if (level <= 3) return Colors.grey;
//     if (level <= 6) return Colors.blue;
//     if (level <= 8) return Colors.purple;
//     return QuestConstants.primaryGold;
//   }
// }
//
// class _OptimizedQuestCell extends StatefulWidget {
//   final QuestCellId id;
//   final bool isToday;
//   final bool isActive;
//   final QuestData? questData;
//   final Function(QuestCellId) onTap;
//   final Function(QuestCellId?) onHover;
//
//   const _OptimizedQuestCell({
//     required this.id,
//     required this.isToday,
//     required this.isActive,
//     this.questData,
//     required this.onTap,
//     required this.onHover,
//   });
//
//   @override
//   State<_OptimizedQuestCell> createState() => _OptimizedQuestCellState();
// }
//
// class _OptimizedQuestCellState extends State<_OptimizedQuestCell>
//     with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
//
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   bool _isHovered = false;
//
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _animationController = AnimationController(
//       vsync: this,
//       duration: QuestConstants.fastAnimation,
//     );
//
//     _scaleAnimation = Tween<double>(
//       begin: 1.0,
//       end: 1.05,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOutBack,
//     ));
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   void _onHoverChanged(bool isHovered) {
//     if (_isHovered != isHovered) {
//       setState(() {
//         _isHovered = isHovered;
//       });
//
//       if (isHovered) {
//         _animationController.forward();
//         widget.onHover(widget.id);
//       } else {
//         _animationController.reverse();
//         widget.onHover(null);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//
//     final isCompleted = widget.questData?.isCompleted ?? false;
//
//     return MouseRegion(
//       onEnter: (_) => _onHoverChanged(true),
//       onExit: (_) => _onHoverChanged(false),
//       child: AnimatedBuilder(
//         animation: _scaleAnimation,
//         builder: (context, child) {
//           return Transform.scale(
//             scale: _scaleAnimation.value,
//             child: Container(
//               margin: const EdgeInsets.all(2),
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: widget.isToday
//                       ? Colors.blueAccent
//                       : _isHovered || widget.isActive
//                       ? Colors.blue.withOpacity(0.5)
//                       : Colors.transparent,
//                   width: widget.isToday ? 2 : 1,
//                 ),
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: (_isHovered || widget.isActive) ? [
//                   BoxShadow(
//                     color: Colors.blue.withOpacity(0.2),
//                     blurRadius: 8,
//                     spreadRadius: 1,
//                   ),
//                 ] : null,
//               ),
//               child: Material(
//                 color: Colors.transparent,
//                 borderRadius: BorderRadius.circular(8),
//                 child: InkWell(
//                   borderRadius: BorderRadius.circular(8),
//                   onTap: () => widget.onTap(widget.id),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       gradient: _buildGradient(isCompleted),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     padding: const EdgeInsets.all(8),
//                     child: _buildCellContent(isCompleted),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   LinearGradient _buildGradient(bool isCompleted) {
//     if (isCompleted) {
//       return QuestConstants.completedGradient;
//     }
//
//     if (_isHovered || widget.isActive) {
//       return QuestConstants.questGradient;
//     }
//
//     return LinearGradient(
//       colors: [
//         Colors.grey[100]!,
//         Colors.grey[200]!,
//       ],
//     );
//   }
//
//   Widget _buildCellContent(bool isCompleted) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // Contenu principal
//         if (widget.questData?.emoji != null) ...[
//           TweenAnimationBuilder<double>(
//             tween: Tween(begin: 0, end: isCompleted ? 1.2 : 1.0),
//             duration: QuestConstants.mediumAnimation,
//             curve: Curves.elasticOut,
//             builder: (context, scale, child) {
//               return Transform.scale(
//                 scale: scale,
//                 child: Text(
//                   widget.questData!.emoji!,
//                   style: const TextStyle(fontSize: 24),
//                 ),
//               );
//             },
//           ),
//         ] else if (isCompleted) ...[
//           TweenAnimationBuilder<double>(
//             tween: Tween(begin: 0, end: 1),
//             duration: QuestConstants.mediumAnimation,
//             curve: Curves.elasticOut,
//             builder: (context, value, child) {
//               return Transform.scale(
//                 scale: value,
//                 child: const Icon(
//                   Icons.check_circle,
//                   color: Colors.white,
//                   size: 28,
//                 ),
//               );
//             },
//           ),
//         ],
//
//         // Informations secondaires
//         if (widget.questData?.duration != null) ...[
//           const SizedBox(height: 4),
//           _buildDurationChip(),
//         ],
//
//         // Indicateur de série
//         if (widget.questData?.streak != null && widget.questData!.streak > 0) ...[
//           const SizedBox(height: 2),
//           _buildStreakIndicator(),
//         ],
//       ],
//     );
//   }
//
//   Widget _buildDurationChip() {
//     return AnimatedContainer(
//       duration: QuestConstants.fastAnimation,
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         '${widget.questData!.duration!.round()}min',
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 10,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStreakIndicator() {
//     return AnimatedContainer(
//       duration: QuestConstants.fastAnimation,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TweenAnimationBuilder<double>(
//             tween: Tween(begin: 0, end: 1),
//             duration: QuestConstants.mediumAnimation,
//             curve: Curves.elasticOut,
//             builder: (context, value, child) {
//               return Transform.scale(
//                 scale: 0.8 + (0.2 * value),
//                 child: const Icon(
//                   Icons.local_fire_department,
//                   color: Colors.orange,
//                   size: 12,
//                 ),
//               );
//             },
//           ),
//           const SizedBox(width: 2),
//           AnimatedCounter(
//             value: widget.questData!.streak,
//             style: const TextStyle(
//               color: Colors.orange,
//               fontSize: 10,
//               fontWeight: FontWeight.bold,
//             ),
//             duration: QuestConstants.fastAnimation,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // lib/quest_tracker/widgets/weekly_summary_card.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class WeeklySummaryCard extends ConsumerWidget {
//   final List<DateTime> weekDates;
//
//   const WeeklySummaryCard({
//     super.key,
//     required this.weekDates,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final stats = ref.watch(questMatrixProvider.notifier).getWeeklyStats(weekDates.length);
//     final gamificationState = ref.watch(gamificationProvider);
//
//     return Card(
//       elevation: 8,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: QuestConstants.questGradient,
//         ),
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             // En-tête
//             const Row(
//               children: [
//                 Icon(Icons.analytics, color: Colors.white, size: 24),
//                 SizedBox(width: 8),
//                 Text(
//                   'Résumé Hebdomadaire',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//
//             // Statistiques principales
//             Row(
//               children: [
//                 Expanded(
//                   child: _StatCard(
//                     title: 'Complétées',
//                     value: stats['completed']!,
//                     total: stats['possible']!,
//                     icon: Icons.check_circle_outline,
//                     color: Colors.green,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _StatCard(
//                     title: 'Série Max',
//                     value: stats['longest_streak']!,
//                     icon: Icons.local_fire_department,
//                     color: Colors.orange,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//
//             // Barre de progression XP
//             XPBar(
//               currentXP: gamificationState.currentLevelXP,
//               maxXP: gamificationState.nextLevelXP,
//               level: gamificationState.level,
//             ),
//             const SizedBox(height: 16),
//
//             // Pourcentage de completion
//             TweenAnimationBuilder<double>(
//               tween: Tween(begin: 0, end: stats['percentage']! / 100),
//               duration: const Duration(milliseconds: 1000),
//               curve: Curves.easeOutQuart,
//               builder: (context, value, child) {
//                 return CircularProgressIndicator(
//                   value: value,
//                   strokeWidth: 8,
//                   backgroundColor: Colors.white.withOpacity(0.3),
//                   valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
//                 );
//               },
//             ),
//             const SizedBox(height: 8),
//             Text(
//               '${stats['percentage']}% Complété',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _StatCard extends StatelessWidget {
//   final String title;
//   final int value;
//   final int? total;
//   final IconData icon;
//   final Color color;
//
//   const _StatCard({
//     required this.title,
//     required this.value,
//     this.total,
//     required this.icon,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.2),
//         ),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 24),
//           const SizedBox(height: 8),
//           AnimatedCounter(
//             value: value,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           if (total != null) ...[
//             Text(
//               '/$total',
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.7),
//                 fontSize: 14,
//               ),
//             ),
//           ],
//           const SizedBox(height: 4),
//           Text(
//             title,
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.9),
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // lib/quest_tracker/utils/error_handling.dart
// import 'package:flutter/material.dart';
// import 'package:logging/logging.dart';
//
// class QuestErrorHandler {
//   static final Logger _logger = Logger('QuestTracker');
//
//   static void initialize() {
//     Logger.root.level = Level.INFO;
//     Logger.root.onRecord.listen((record) {
//       debugPrint('${record.level.name}: ${record.time}: ${record.message}');
//       if (record.error != null) {
//         debugPrint('Error: ${record.error}');
//       }
//       if (record.stackTrace != null) {
//         debugPrint('Stack trace: ${record.stackTrace}');
//       }
//     });
//   }
//
//   static void logError(String message, [Object? error, StackTrace? stackTrace]) {
//     _logger.severe(message, error, stackTrace);
//   }
//
//   static void logWarning(String message) {
//     _logger.warning(message);
//   }
//
//   static void logInfo(String message) {
//     _logger.info(message);
//   }
//
//   static Widget buildErrorWidget(FlutterErrorDetails details) {
//     logError('Widget Error', details.exception, details.stack);
//
//     return Material(
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.error_outline,
//               color: Colors.red,
//               size: 48,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Une erreur est survenue',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Détails: ${details.exception}',
//               style: const TextStyle(fontSize: 14),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // lib/quest_tracker/utils/performance_monitor.dart
// import 'package:flutter/foundation.dart';
// import 'package:flutter/scheduler.dart';
//
// class PerformanceMonitor {
//   static final Map<String, Stopwatch> _stopwatches = {};
//   static final List<FrameTiming> _frameTimings = [];
//   static bool _isMonitoring = false;
//
//   static void startMonitoring() {
//     if (_isMonitoring) return;
//
//     _isMonitoring = true;
//     SchedulerBinding.instance.addTimingsCallback(_onFrameTiming);
//   }
//
//   static void stopMonitoring() {
//     if (!_isMonitoring) return;
//
//     _isMonitoring = false;
//     SchedulerBinding.instance.removeTimingsCallback(_onFrameTiming);
//   }
//
//   static void startTimer(String name) {
//     _stopwatches[name] = Stopwatch()..start();
//   }
//
//   static void endTimer(String name) {
//     final stopwatch = _stopwatches.remove(name);
//     if (stopwatch != null) {
//       final duration = stopwatch.elapsedMilliseconds;
//       if (kDebugMode) {
//         print('⏱️ $name: ${duration}ms');
//       }
//
//       if (duration > 16) { // > 16ms = potential jank
//         QuestErrorHandler.logWarning('Potential jank detected in $name: ${duration}ms');
//       }
//     }
//   }
//
//   static void _onFrameTiming(List<FrameTiming> timings) {
//     _frameTimings.addAll(timings);
//
//     // Keep only last 60 frames
//     if (_frameTimings.length > 60) {
//       _frameTimings.removeRange(0, _frameTimings.length - 60);
//     }
//
//     // Check for jank
//     for (final timing in timings) {
//       final frameDuration = timing.totalSpan.inMicroseconds / 1000; // Convert to milliseconds
//       if (frameDuration > 16.67) { // 60fps = 16.67ms per frame
//         QuestErrorHandler.logWarning('Frame jank detected: ${frameDuration.toStringAsFixed(2)}ms');
//       }
//     }
//   }
//
//   static double get averageFrameTime {
//     if (_frameTimings.isEmpty) return 0;
//
//     final totalTime = _frameTimings
//         .map((timing) => timing.totalSpan.inMicroseconds)
//         .reduce((a, b) => a + b);
//
//     return (totalTime / _frameTimings.length) / 1000; // Convert to milliseconds
//   }
//
//   static int get droppedFrames {
//     return _frameTimings.where((timing) =>
//     timing.totalSpan.inMicroseconds > 16670 // > 16.67ms
//     ).length;
//   }
// }