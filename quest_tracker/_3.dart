// // lib/quest_tracker/utils/constants.dart
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
//
//   // Niveaux de difficulté
//   static const Map<QuestDifficulty, int> difficultyXP = {
//     QuestDifficulty.easy: 10,
//     QuestDifficulty.normal: 15,
//     QuestDifficulty.hard: 25,
//     QuestDifficulty.epic: 40,
//   };
// }
//
// // lib/quest_tracker/utils/animations.dart
// import 'package:flutter/material.dart';
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
//
//   // Animation de particules pour les récompenses
//   static Widget createParticleExplosion({
//     required Widget child,
//     required bool trigger,
//   }) {
//     return AnimatedContainer(
//       duration: QuestConstants.mediumAnimation,
//       child: Stack(
//         children: [
//           child,
//           if (trigger) ...[
//             ...List.generate(8, (index) {
//               final angle = (index * 45) * (3.14159 / 180);
//               return AnimatedPositioned(
//                 duration: QuestConstants.slowAnimation,
//                 left: 50 + (30 * cos(angle)),
//                 top: 50 + (30 * sin(angle)),
//                 child: Container(
//                   width: 4,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: Colors.yellow,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               );
//             }),
//           ],
//         ],
//       ),
//     );
//   }
// }
//
// // lib/quest_tracker/widgets/animated_counter.dart
// import 'package:flutter/material.dart';
//
// class AnimatedCounter extends StatefulWidget {
//   final int value;
//   final TextStyle? style;
//   final Duration duration;
//
//   const AnimatedCounter({
//     super.key,
//     required this.value,
//     this.style,
//     this.duration = const Duration(milliseconds: 500),
//   });
//
//   @override
//   State<AnimatedCounter> createState() => _AnimatedCounterState();
// }
//
// class _AnimatedCounterState extends State<AnimatedCounter>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   int _previousValue = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: widget.duration,
//     );
//     _animation = Tween<double>(
//       begin: 0,
//       end: widget.value.toDouble(),
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOutQuart,
//     ));
//     _controller.forward();
//   }
//
//   @override
//   void didUpdateWidget(AnimatedCounter oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.value != widget.value) {
//       _previousValue = oldWidget.value;
//       _animation = Tween<double>(
//         begin: _previousValue.toDouble(),
//         end: widget.value.toDouble(),
//       ).animate(CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeOutQuart,
//       ));
//       _controller
//         ..reset()
//         ..forward();
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return Text(
//           _animation.value.round().toString(),
//           style: widget.style,
//         );
//       },
//     );
//   }
// }
//
// // lib/quest_tracker/widgets/xp_bar.dart
// import 'package:flutter/material.dart';
//
// class XPBar extends StatefulWidget {
//   final int currentXP;
//   final int maxXP;
//   final int level;
//
//   const XPBar({
//     super.key,
//     required this.currentXP,
//     required this.maxXP,
//     required this.level,
//   });
//
//   @override
//   State<XPBar> createState() => _XPBarState();
// }
//
// class _XPBarState extends State<XPBar>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fillAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//     _fillAnimation = Tween<double>(
//       begin: 0,
//       end: widget.currentXP / widget.maxXP,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOutQuart,
//     ));
//     _controller.forward();
//   }
//
//   @override
//   void didUpdateWidget(XPBar oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.currentXP != widget.currentXP) {
//       _fillAnimation = Tween<double>(
//         begin: oldWidget.currentXP / oldWidget.maxXP,
//         end: widget.currentXP / widget.maxXP,
//       ).animate(CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeOutQuart,
//       ));
//       _controller
//         ..reset()
//         ..forward();
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 24,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: Colors.grey[300],
//       ),
//       child: Stack(
//         children: [
//           // Barre de fond
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: Colors.grey[300],
//             ),
//           ),
//
//           // Barre de progression animée
//           AnimatedBuilder(
//             animation: _fillAnimation,
//             builder: (context, child) {
//               return Container(
//                 width: MediaQuery.of(context).size.width * _fillAnimation.value,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   gradient: QuestConstants.levelGradient,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.purple.withOpacity(0.3),
//                       blurRadius: 8,
//                       spreadRadius: 1,
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//
//           // Texte centré
//           Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Niveau ${widget.level}',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 AnimatedCounter(
//                   value: widget.currentXP,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12,
//                   ),
//                 ),
//                 Text(
//                   '/${widget.maxXP} XP',
//                   style: const TextStyle(
//                     color: Colors.white70,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // lib/quest_tracker/widgets/achievement_popup.dart
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class AchievementPopup extends StatefulWidget {
//   final String title;
//   final String description;
//   final String icon;
//   final Color color;
//   final VoidCallback? onDismiss;
//
//   const AchievementPopup({
//     super.key,
//     required this.title,
//     required this.description,
//     required this.icon,
//     this.color = Colors.gold,
//     this.onDismiss,
//   });
//
//   @override
//   State<AchievementPopup> createState() => _AchievementPopupState();
// }
//
// class _AchievementPopupState extends State<AchievementPopup>
//     with TickerProviderStateMixin {
//   late AnimationController _slideController;
//   late AnimationController _scaleController;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _slideController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//
//     _scaleController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, -1),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _slideController,
//       curve: Curves.elasticOut,
//     ));
//
//     _scaleAnimation = Tween<double>(
//       begin: 0.5,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _scaleController,
//       curve: Curves.elasticOut,
//     ));
//
//     _startAnimation();
//     _scheduleAutoDismiss();
//   }
//
//   void _startAnimation() async {
//     // Haptic feedback
//     HapticFeedback.heavyImpact();
//
//     await Future.wait([
//       _slideController.forward(),
//       _scaleController.forward(),
//     ]);
//   }
//
//   void _scheduleAutoDismiss() {
//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted) {
//         _dismiss();
//       }
//     });
//   }
//
//   void _dismiss() async {
//     await Future.wait([
//       _slideController.reverse(),
//       _scaleController.reverse(),
//     ]);
//
//     if (widget.onDismiss != null) {
//       widget.onDismiss!();
//     }
//   }
//
//   @override
//   void dispose() {
//     _slideController.dispose();
//     _scaleController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: Listenable.merge([_slideAnimation, _scaleAnimation]),
//       builder: (context, child) {
//         return SlideTransition(
//           position: _slideAnimation,
//           child: Transform.scale(
//             scale: _scaleAnimation.value,
//             child: GestureDetector(
//               onTap: _dismiss,
//               child: Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: widget.color.withOpacity(0.3),
//                       blurRadius: 20,
//                       spreadRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 60,
//                       height: 60,
//                       decoration: BoxDecoration(
//                         color: widget.color.withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Center(
//                         child: Text(
//                           widget.icon,
//                           style: const TextStyle(fontSize: 30),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             widget.title,
//                             style: TextStyle(
//                               color: widget.color,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             widget.description,
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// // lib/quest_tracker/services/achievement_service.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
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
//     this.color = Colors.gold,
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
// class AchievementService extends StateNotifier<List<Achievement>> {
//   AchievementService() : super(_defaultAchievements);
//
//   static final List<Achievement> _defaultAchievements = [
//     Achievement(
//       id: 'first_quest',
//       title: 'Première Quête',
//       description: 'Complète ta première quête',
//       icon: '🎯',
//       color: Colors.blue,
//     ),
//     Achievement(
//       id: 'streak_3',
//       title: 'Série de 3',
//       description: 'Maintiens une série de 3 jours',
//       icon: '🔥',
//       color: Colors.orange,
//     ),
//     Achievement(
//       id: 'streak_7',
//       title: 'Semaine Parfaite',
//       description: 'Complète toutes les quêtes pendant 7 jours',
//       icon: '👑',
//       color: Colors.purple,
//     ),
//     Achievement(
//       id: 'level_5',
//       title: 'Niveau 5',
//       description: 'Atteins le niveau 5',
//       icon: '⭐',
//       color: Colors.yellow,
//     ),
//     Achievement(
//       id: 'completionist',
//       title: 'Perfectionniste',
//       description: 'Complète 100 quêtes',
//       icon: '🏆',
//       color: Colors.gold,
//     ),
//   ];
//
//   void checkAchievements({
//     required int totalCompleted,
//     required int currentStreak,
//     required int level,
//   }) {
//     final now = DateTime.now();
//     bool hasNewAchievement = false;
//
//     state = state.map((achievement) {
//       if (achievement.isUnlocked) return achievement;
//
//       bool shouldUnlock = false;
//
//       switch (achievement.id) {
//         case 'first_quest':
//           shouldUnlock = totalCompleted >= 1;
//           break;
//         case 'streak_3':
//           shouldUnlock = currentStreak >= 3;
//           break;
//         case 'streak_7':
//           shouldUnlock = currentStreak >= 7;
//           break;
//         case 'level_5':
//           shouldUnlock = level >= 5;
//           break;
//         case 'completionist':
//           shouldUnlock = totalCompleted >= 100;
//           break;
//       }
//
//       if (shouldUnlock) {
//         hasNewAchievement = true;
//         return achievement.copyWith(
//           isUnlocked: true,
//           unlockedAt: now,
//         );
//       }
//
//       return achievement;
//     }).toList();
//
//     if (hasNewAchievement) {
//       _notifyNewAchievements();
//     }
//   }
//
//   void _notifyNewAchievements() {
//     // Cette méthode sera appelée par le provider principal
//     // pour afficher les nouvelles réalisations
//   }
//
//   List<Achievement> get unlockedAchievements =>
//       state.where((a) => a.isUnlocked).toList();
//
//   List<Achievement> get lockedAchievements =>
//       state.where((a) => !a.isUnlocked).toList();
// }
//
// final achievementProvider = StateNotifierProvider<AchievementService, List<Achievement>>((ref) {
//   return AchievementService();
// });
//
// // lib/quest_tracker/widgets/quest_cell_improved.dart
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class QuestCellImproved extends ConsumerStatefulWidget {
//   final QuestCellId id;
//   final bool isActive;
//   final Function(QuestCellId) onTap;
//   final Function(QuestCellId?) onHover;
//
//   const QuestCellImproved({
//     super.key,
//     required this.id,
//     required this.isActive,
//     required this.onTap,
//     required this.onHover,
//   });
//
//   @override
//   ConsumerState<QuestCellImproved> createState() => _QuestCellImprovedState();
// }
//
// class _QuestCellImprovedState extends ConsumerState<QuestCellImproved>
//     with TickerProviderStateMixin {
//
//   late AnimationController _pulseController;
//   late AnimationController _completeController;
//   late Animation<double> _pulseAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<Color?> _colorAnimation;
//
//   bool _isHovered = false;
//   bool _wasCompleted = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     )..repeat(reverse: true);
//
//     _completeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//
//     _pulseAnimation = Tween<double>(
//       begin: 0.95,
//       end: 1.05,
//     ).animate(CurvedAnimation(
//       parent: _pulseController,
//       curve: Curves.easeInOut,
//     ));
//
//     _scaleAnimation = Tween<double>(
//       begin: 0.5,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _completeController,
//       curve: Curves.elasticOut,
//     ));
//
//     _colorAnimation = ColorTween(
//       begin: Colors.grey[300],
//       end: Colors.green,
//     ).animate(CurvedAnimation(
//       parent: _completeController,
//       curve: Curves.easeInOut,
//     ));
//   }
//
//   @override
//   void dispose() {
//     _pulseController.dispose();
//     _completeController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final questData = ref.watch(questMatrixProvider)[widget.id];
//     final isCompleted = questData?.isCompleted ?? false;
//
//     // Animation de completion
//     if (isCompleted && !_wasCompleted) {
//       _wasCompleted = true;
//       _completeController.forward();
//       HapticFeedback.heavyImpact();
//     } else if (!isCompleted && _wasCompleted) {
//       _wasCompleted = false;
//       _completeController.reverse();
//     }
//
//     return MouseRegion(
//       onEnter: (_) {
//         setState(() => _isHovered = true);
//         widget.onHover(widget.id);
//       },
//       onExit: (_) {
//         setState(() => _isHovered = false);
//         widget.onHover(null);
//       },
//       child: GestureDetector(
//         onTap: () {
//           HapticFeedback.mediumImpact();
//           widget.onTap(widget.id);
//         },
//         child: AnimatedBuilder(
//           animation: Listenable.merge([
//             _pulseAnimation,
//             _scaleAnimation,
//             _colorAnimation,
//           ]),
//           builder: (context, child) {
//             return Transform.scale(
//               scale: _isHovered ? 1.02 : 1.0,
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   gradient: _buildGradient(questData),
//                   boxShadow: _buildShadow(isCompleted),
//                 ),
//                 child: Material(
//                   color: Colors.transparent,
//                   borderRadius: BorderRadius.circular(12),
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(12),
//                     onTap: () => widget.onTap(widget.id),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       child: _buildContent(questData, isCompleted),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   LinearGradient _buildGradient(QuestData? questData) {
//     if (questData?.isCompleted == true) {
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
//   List<BoxShadow> _buildShadow(bool isCompleted) {
//     if (isCompleted) {
//       return [
//         BoxShadow(
//           color: Colors.green.withOpacity(0.3),
//           blurRadius: 12,
//           spreadRadius: 2,
//         ),
//       ];
//     }
//
//     if (_isHovered || widget.isActive) {
//       return [
//         BoxShadow(
//           color: Colors.blue.withOpacity(0.2),
//           blurRadius: 8,
//           spreadRadius: 1,
//         ),
//       ];
//     }
//
//     return [];
//   }
//
//   Widget _buildContent(QuestData? questData, bool isCompleted) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // Emoji ou icône
//         if (questData?.emoji != null) ...[
//           Text(
//             questData!.emoji!,
//             style: TextStyle(
//               fontSize: isCompleted ? 32 : 24,
//             ),
//           ),
//         ] else if (isCompleted) ...[
//           const Icon(
//             Icons.check_circle,
//             color: Colors.white,
//             size: 32,
//           ),
//         ],
//
//         // Durée si définie
//         if (questData?.duration != null) ...[
//           const SizedBox(height: 4),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Text(
//               '${questData!.duration!.round()}min',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 10,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//
//         // Indicateur de série
//         if (questData?.streak != null && questData!.streak > 0) ...[
//           const SizedBox(height: 2),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.local_fire_department,
//                 color: Colors.orange,
//                 size: 12,
//               ),
//               Text(
//                 questData.streak.toString(),
//                 style: const TextStyle(
//                   color: Colors.orange,
//                   fontSize: 10,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ],
//     );
//   }
// }
//
// // lib/quest_tracker/widgets/gamification_overlay.dart
// import 'package:flutter/material.dart';
//
// class GamificationOverlay extends StatefulWidget {
//   final Widget child;
//
//   const GamificationOverlay({
//     super.key,
//     required this.child,
//   });
//
//   @override
//   State<GamificationOverlay> createState() => _GamificationOverlayState();
// }
//
// class _GamificationOverlayState extends State<GamificationOverlay> {
//   final List<AchievementPopup> _activePopups = [];
//
//   void _showAchievement(Achievement achievement) {
//     setState(() {
//       _activePopups.add(
//         AchievementPopup(
//           title: achievement.title,
//           description: achievement.description,
//           icon: achievement.icon,
//           color: achievement.color,
//           onDismiss: () {
//             setState(() {
//               _activePopups.removeWhere((popup) =>
//               popup.title == achievement.title
//               );
//             });
//           },
//         ),
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         widget.child,
//
//         // Overlay pour les réalisations
//         ...List.generate(_activePopups.length, (index) {
//           return Positioned(
//             top: 100 + (index * 100.0),
//             left: 0,
//             right: 0,
//             child: _activePopups[index],
//           );
//         }),
//       ],
//     );
//   }
// }
//
// // lib/quest_tracker/providers/gamification_provider.dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';
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
// // Extension pour les imports manquants
// import 'dart:math' show cos, sin;