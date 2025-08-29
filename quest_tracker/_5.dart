// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'quest_tracker/screens/quest_week_view.dart';
//
// void main() {
//   runApp(
//     const ProviderScope(
//       child: MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Quest Tracker RPG',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: Scaffold(
//         body: QuestWeekView(
//           weekDates: List.generate(7, (index) {
//             final now = DateTime.now();
//             final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
//             return startOfWeek.add(Duration(days: index));
//           }),
//         ),
//       ),
//     );
//   }
// }
//
// // =====================================
// // lib/quest_tracker/models/quest_cell_id.dart
// // =====================================
// class QuestCellId {
//   final int row;
//   final int col;
//
//   const QuestCellId(this.row, this.col);
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//           other is QuestCellId && row == other.row && col == other.col;
//
//   @override
//   int get hashCode => Object.hash(row, col);
//
//   @override
//   String toString() => 'QuestCellId(row: $row, col: $col)';
// }
//
// // =====================================
// // lib/quest_tracker/models/quest_data.dart
// // =====================================
// import 'package:flutter/material.dart';
//
// enum QuestDifficulty {
//   easy(multiplier: 1.0, color: Colors.green),
//   normal(multiplier: 1.5, color: Colors.blue),
//   hard(multiplier: 2.0, color: Colors.orange),
//   epic(multiplier: 3.0, color: Colors.purple);
//
//   const QuestDifficulty({
//     required this.multiplier,
//     required this.color,
//   });
//
//   final double multiplier;
//   final Color color;
// }
//
// class QuestData {
//   final String? emoji;
//   final double? duration;
//   final int streak;
//   final String? notes;
//   final bool isCompleted;
//   final DateTime? completedAt;
//   final int xpReward;
//   final QuestDifficulty difficulty;
//
//   const QuestData({
//     this.emoji,
//     this.duration,
//     this.streak = 0,
//     this.notes,
//     this.isCompleted = false,
//     this.completedAt,
//     this.xpReward = 10,
//     this.difficulty = QuestDifficulty.normal,
//   });
//
//   QuestData copyWith({
//     String? emoji,
//     double? duration,
//     int? streak,
//     String? notes,
//     bool? isCompleted,
//     DateTime? completedAt,
//     int? xpReward,
//     QuestDifficulty? difficulty,
//   }) {
//     return QuestData(
//       emoji: emoji ?? this.emoji,
//       duration: duration ?? this.duration,
//       streak: streak ?? this.streak,
//       notes: notes ?? this.notes,
//       isCompleted: isCompleted ?? this.isCompleted,
//       completedAt: completedAt ?? this.completedAt,
//       xpReward: xpReward ?? this.xpReward,
//       difficulty: difficulty ?? this.difficulty,
//     );
//   }
// }
//
// // =====================================
// // lib/quest_tracker/models/achievement.dart
// // =====================================
// import 'package:flutter/material.dart';
//
// class Achievement {
//   final String id;
//   final String title;
//   final String description;
//   final String icon;
//   final Color color;
//   final bool isUnlocked;
//   final DateTime? unlockedAt;
//
//   const Achievement({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.icon,
//     this.color = Colors.amber,
//     this.isUnlocked = false,
//     this.unlockedAt,
//   });
//
//   Achievement copyWith({
//     bool? isUnlocked,
//     DateTime? unlockedAt,
//   }) {
//     return Achievement(
//       id: id,
//       title: title,
//       description: description,
//       icon: icon,
//       color: color,
//       isUnlocked: isUnlocked ?? this.isUnlocked,
//       unlockedAt: unlockedAt ?? this.unlockedAt,
//     );
//   }
// }
//
// // =====================================
// // lib/quest_tracker/providers/active_cell_provider.dart
// // =====================================
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/quest_cell_id.dart';
//
// final activeCellProvider = StateProvider<QuestCellId?>((ref) => null);
//
// // =====================================
// // lib/quest_tracker/providers/haptic_provider.dart
// // =====================================
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// enum HapticFeedbackType {
//   lightImpact,
//   mediumImpact,
//   heavyImpact,
// }
//
// class HapticState {
//   final bool isEnabled;
//   const HapticState({this.isEnabled = true});
// }
//
// class HapticNotifier extends StateNotifier<HapticState> {
//   HapticNotifier() : super(const HapticState());
//
//   void impact(HapticFeedbackType type) {
//     if (state.isEnabled) {
//       switch (type) {
//         case HapticFeedbackType.lightImpact:
//           HapticFeedback.lightImpact();
//           break;
//         case HapticFeedbackType.mediumImpact:
//           HapticFeedback.mediumImpact();
//           break;
//         case HapticFeedbackType.heavyImpact:
//           HapticFeedback.heavyImpact();
//           break;
//       }
//     }
//   }
//
//   void selection() {
//     if (state.isEnabled) {
//       HapticFeedback.selectionClick();
//     }
//   }
//
//   void toggleEnabled() {
//     state = HapticState(isEnabled: !state.isEnabled);
//   }
// }
//
// final hapticProvider = StateNotifierProvider<HapticNotifier, HapticState>((ref) {
//   return HapticNotifier();
// });
//
// // =====================================
// // lib/quest_tracker/providers/quest_matrix_provider.dart
// // =====================================
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/quest_cell_id.dart';
// import '../models/quest_data.dart';
//
// class QuestMatrixNotifier extends StateNotifier<Map<QuestCellId, QuestData>> {
//   QuestMatrixNotifier() : super({});
//
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
//     final current = state[id] ?? const QuestData();
//     state = {
//       ...state,
//       id: current.copyWith(emoji: emoji),
//     };
//   }
//
//   void setDuration(QuestCellId id, double duration) {
//     final current = state[id] ?? const QuestData();
//     state = {
//       ...state,
//       id: current.copyWith(duration: duration),
//     };
//   }
//
//   void setNotes(QuestCellId id, String notes) {
//     final current = state[id] ?? const QuestData();
//     state = {
//       ...state,
//       id: current.copyWith(notes: notes.isEmpty ? null : notes),
//     };
//   }
//
//   void toggleComplete(QuestCellId id) {
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
//   }
//
//   void reset(QuestCellId id) {
//     state = {
//       ...state,
//       id: const QuestData(),
//     };
//   }
//
//   int _calculateNewStreak(QuestCellId id) {
//     final currentRow = id.row;
//     final currentCol = id.col;
//     int streak = 1;
//
//     for (int col = currentCol - 1; col >= 0; col--) {
//       final prevId = QuestCellId(currentRow, col);
//       final prevData = state[prevId];
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
//   double getQuestCompletionRate(int questIndex, int weekLength) {
//     int completed = 0;
//     for (int col = 0; col < weekLength; col++) {
//       final id = QuestCellId(questIndex, col);
//       if (state[id]?.isCompleted == true) {
//         completed++;
//       }
//     }
//     return completed / weekLength;
//   }
//
//   Map<String, int> getWeeklyStats(int weekLength) {
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
//     return {
//       'completed': totalCompleted,
//       'possible': totalPossible,
//       'percentage': totalPossible > 0 ? ((totalCompleted / totalPossible) * 100).round() : 0,
//       'longest_streak': longestStreak,
//     };
//   }
// }
//
// final questMatrixProvider = StateNotifierProvider<QuestMatrixNotifier, Map<QuestCellId, QuestData>>((ref) {
//   return QuestMatrixNotifier();
// });
//
// // =====================================
// // lib/quest_tracker/providers/gamification_provider.dart
// // =====================================
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/achievement.dart';
// import '../models/quest_data.dart';
// import '../utils/constants.dart';
//
// class GamificationState {
//   final int totalXP;
//   final int level;
//   final int currentLevelXP;
//   final int nextLevelXP;
//   final int totalQuestsCompleted;
//   final int longestStreak;
//   final int currentStreak;
//   final List<Achievement> unlockedAchievements;
//
//   const GamificationState({
//     this.totalXP = 0,
//     this.level = 1,
//     this.currentLevelXP = 0,
//     this.nextLevelXP = 100,
//     this.totalQuestsCompleted = 0,
//     this.longestStreak = 0,
//     this.currentStreak = 0,
//     this.unlockedAchievements = const [],
//   });
//
//   GamificationState copyWith({
//     int? totalXP,
//     int? level,
//     int? currentLevelXP,
//     int? nextLevelXP,
//     int? totalQuestsCompleted,
//     int? longestStreak,
//     int? currentStreak,
//     List<Achievement>? unlockedAchievements,
//   }) {
//     return GamificationState(
//       totalXP: totalXP ?? this.totalXP,
//       level: level ?? this.level,
//       currentLevelXP: currentLevelXP ?? this.currentLevelXP,
//       nextLevelXP: nextLevelXP ?? this.nextLevelXP,
//       totalQuestsCompleted: totalQuestsCompleted ?? this.totalQuestsCompleted,
//       longestStreak: longestStreak ?? this.longestStreak,
//       currentStreak: currentStreak ?? this.currentStreak,
//       unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
//     );
//   }
// }
//
// class GamificationNotifier extends StateNotifier<GamificationState> {
//   GamificationNotifier() : super(const GamificationState());
//
//   void addXP(int xp) {
//     final newTotalXP = state.totalXP + xp;
//     final newLevel = _calculateLevel(newTotalXP);
//     final levelXP = _getLevelXP(newLevel);
//
//     state = state.copyWith(
//       totalXP: newTotalXP,
//       level: newLevel,
//       currentLevelXP: newTotalXP % levelXP,
//       nextLevelXP: levelXP,
//     );
//   }
//
//   void questCompleted(QuestData questData) {
//     final baseXP = QuestConstants.baseXP;
//     final difficultyMultiplier = questData.difficulty.multiplier;
//     final streakBonus = questData.streak * QuestConstants.streakBonus;
//     final totalXP = ((baseXP * difficultyMultiplier) + streakBonus).round();
//
//     addXP(totalXP);
//
//     state = state.copyWith(
//       totalQuestsCompleted: state.totalQuestsCompleted + 1,
//       currentStreak: questData.streak,
//       longestStreak: questData.streak > state.longestStreak
//           ? questData.streak
//           : state.longestStreak,
//     );
//   }
//
//   int _calculateLevel(int totalXP) {
//     return (totalXP / 100).floor() + 1;
//   }
//
//   int _getLevelXP(int level) {
//     return 100 + ((level - 1) * 50);
//   }
// }
//
// final gamificationProvider = StateNotifierProvider<GamificationNotifier, GamificationState>((ref) {
//   return GamificationNotifier();
// });
//
// // =====================================
// // lib/quest_tracker/utils/constants.dart
// // =====================================
// import 'package:flutter/material.dart';
//
// class QuestConstants {
//   // Animations
//   static const Duration fastAnimation = Duration(milliseconds: 150);
//   static const Duration mediumAnimation = Duration(milliseconds: 300);
//   static const Duration slowAnimation = Duration(milliseconds: 600);
//   static const Duration staggerDelay = Duration(milliseconds: 80);
//
//   // Courbes d'animation
//   static const Curve elasticCurve = Curves.elasticOut;
//   static const Curve bounceCurve = Curves.bounceOut;
//   static const Curve smoothCurve = Curves.easeInOutCubic;
//
//   // Dimensions
//   static const double cellHeight = 80.0;
//   static const double dockRadius = 28.0;
//   static const double fabSize = 48.0;
//   static const double menuWidth = 280.0;
//
//   // Couleurs
//   static const Color primaryGold = Color(0xFFFFD700);
//   static const Color secondaryBlue = Color(0xFF4A90E2);
//   static const Color successGreen = Color(0xFF4CAF50);
//   static const Color warningOrange = Color(0xFFFF9800);
//   static const Color errorRed = Color(0xFFF44336);
//
//   // Gradients
//   static const LinearGradient questGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [
//       Color(0xFF667eea),
//       Color(0xFF764ba2),
//     ],
//   );
//
//   static const LinearGradient completedGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [
//       Color(0xFF11998e),
//       Color(0xFF38ef7d),
//     ],
//   );
//
//   static const LinearGradient levelGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [
//       Color(0xFFf093fb),
//       Color(0xFFf5576c),
//     ],
//   );
//
//   // Système XP
//   static const int baseXP = 10;
//   static const int streakBonus = 5;
//   static const int perfectWeekBonus = 50;
// }
//
// // =====================================
// // lib/quest_tracker/utils/animations.dart
// // =====================================
// import 'package:flutter/material.dart';
// import 'constants.dart';
//
// class QuestAnimations {
//   static Animation<double> createElasticAnimation(
//       AnimationController controller, {
//         double begin = 0.0,
//         double end = 1.0,
//       }) {
//     return Tween<double>(begin: begin, end: end).animate(
//       CurvedAnimation(
//         parent: controller,
//         curve: QuestConstants.elasticCurve,
//       ),
//     );
//   }
//
//   static Animation<Offset> createSlideAnimation(
//       AnimationController controller, {
//         Offset begin = const Offset(0, 1),
//         Offset end = Offset.zero,
//       }) {
//     return Tween<Offset>(begin: begin, end: end).animate(
//       CurvedAnimation(
//         parent: controller,
//         curve: QuestConstants.smoothCurve,
//       ),
//     );
//   }
//
//   static Animation<double> createBounceAnimation(
//       AnimationController controller,
//       ) {
//     return Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(
//         parent: controller,
//         curve: QuestConstants.bounceCurve,
//       ),
//     );
//   }
// }
//
// // =====================================
// // lib/quest_tracker/widgets/quest_cell.dart
// // =====================================
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/quest_cell_id.dart';
// import '../providers/quest_matrix_provider.dart';
// import '../providers/haptic_provider.dart';
//
// class QuestCell extends ConsumerWidget {
//   final QuestCellId id;
//   final bool isActive;
//   final Function(QuestCellId) onTap;
//   final Function(QuestCellId?) onHover;
//
//   const QuestCell({
//     super.key,
//     required this.id,
//     required this.isActive,
//     required this.onTap,
//     required this.onHover,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final questData = ref.watch(questMatrixProvider)[id];
//     final isCompleted = questData?.isCompleted ?? false;
//
//     return Material(
//       color: Colors.transparent,
//       borderRadius: BorderRadius.circular(8),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(8),
//         onTap: () {
//           ref.read(hapticProvider.notifier).impact(HapticFeedbackType.lightImpact);
//           onTap(id);
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: isCompleted
//                 ? const LinearGradient(
//               colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
//             )
//                 : LinearGradient(
//               colors: [Colors.grey[200]!, Colors.grey[300]!],
//             ),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Center(
//             child: questData?.emoji != null
//                 ? Text(
//               questData!.emoji!,
//               style: const TextStyle(fontSize: 24),
//             )
//                 : isCompleted
//                 ? const Icon(
//               Icons.check_circle,
//               color: Colors.white,
//               size: 28,
//             )
//                 : null,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // =====================================
// // lib/quest_tracker/widgets/quest_cell_visual.dart
// // =====================================
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/quest_cell_id.dart';
// import '../providers/quest_matrix_provider.dart';
//
// class QuestCellVisual extends ConsumerWidget {
//   final QuestCellId id;
//   final bool isActive;
//   final bool animated;
//
//   const QuestCellVisual({
//     super.key,
//     required this.id,
//     required this.isActive,
//     this.animated = false,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final questData = ref.watch(questMatrixProvider)[id];
//     final isCompleted = questData?.isCompleted ?? false;
//
//     return Container(
//       decoration: BoxDecoration(
//         gradient: isCompleted
//             ? const LinearGradient(
//           colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
//         )
//             : LinearGradient(
//           colors: [Colors.grey[200]!, Colors.grey[300]!],
//         ),
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: isActive
//             ? [
//           BoxShadow(
//             color: Colors.blue.withOpacity(0.4),
//             blurRadius: 12,
//             spreadRadius: 2,
//           ),
//         ]
//             : null,
//       ),
//       child: Center(
//         child: questData?.emoji != null
//             ? Text(
//           questData!.emoji!,
//           style: TextStyle(fontSize: animated ? 32 : 24),
//         )
//             : isCompleted
//             ? Icon(
//           Icons.check_circle,
//           color: Colors.white,
//           size: animated ? 36 : 28,
//         )
//             : null,
//       ),
//     );
//   }
// }
//
// // =====================================
// // lib/quest_tracker/widgets/week_header.dart
// // =====================================
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class WeekHeader extends StatelessWidget {
//   final List<DateTime> dates;
//
//   const WeekHeader({
//     super.key,
//     required this.dates,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//       decoration: BoxDecoration(
//         color: Theme.of(context).primaryColor.withOpacity(0.1),
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(16),
//           bottomRight: Radius.circular(16),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: dates.map((date) {
//           final isToday = DateUtils.isSameDay(date, DateTime.now());
//           final formatter = DateFormat('E\nd', 'fr_FR');
//
//           return Expanded(
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: isToday
//                   ? BoxDecoration(
//                 color: Theme.of(context).primaryColor,
//                 borderRadius: BorderRadius.circular(8),
//               )
//                   : null,
//               child: Column(
//                 children: [
//                   Text(
//                     DateFormat('E', 'fr_FR').format(date).toUpperCase(),
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: isToday ? Colors.white : Colors.grey[600],
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     DateFormat('d').format(date),
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: isToday ? Colors.white : Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
//
// // =====================================
// // lib/quest_tracker/widgets/week_footer.dart
// // =====================================
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/quest_matrix_provider.dart';
// import '../providers/gamification_provider.dart';
// import 'xp_bar.dart';
//
// class WeekFooter extends ConsumerWidget {
//   final List<DateTime> weekDates;
//   final int totalQuests;
//
//   const WeekFooter({
//     super.key,
//     required this.weekDates,
//     required this.totalQuests,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final stats = ref.watch(questMatrixProvider.notifier).getWeeklyStats(weekDates.length);
//     final gamification = ref.watch(gamificationProvider);
//
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(16),
//           topRight: Radius.circular(16),
//         ),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _StatCard(
//                 icon: Icons.check_circle,
//                 value: '${stats['completed']}/${stats['possible']}',
//                 label: 'Complété',
//                 color: Colors.green,
//               ),
//               _StatCard(
//                 icon: Icons.local_fire_department,
//                 value: stats['longest_streak'].toString(),
//                 label: 'Série Max',
//                 color: Colors.orange,
//               ),
//               _StatCard(
//                 icon: Icons.percent,
//                 value: '${stats['percentage']}%',
//                 label: 'Taux',
//                 color: Colors.blue,
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           XPBar(
//             currentXP: gamification.currentLevelXP,
//             maxXP: gamification.nextLevelXP,
//             level: gamification.level,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _StatCard extends StatelessWidget {
//   final IconData icon;
//   final String value;
//   final String label;
//   final Color color;
//
//   const _StatCard({
//     required this.icon,
//     required this.value,
//     required this.label,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Icon(icon, color: color, size: 24),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey[600],
//           ),
//         ),
//       ],
//     );
//   }
// }
