// // lib/quest_tracker/screens/quest_week_view.dart
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// // Imports
// import '../models/quest_cell_id.dart';
// import '../models/quest_data.dart';
// import '../providers/active_cell_provider.dart';
// import '../providers/quest_matrix_provider.dart';
// import '../providers/haptic_provider.dart';
// import '../widgets/quest_cell.dart';
// import '../widgets/quest_cell_visual.dart';
// import '../widgets/week_footer.dart';
// import '../widgets/week_header.dart';
// import '../utils/constants.dart';
// import '../utils/animations.dart';
//
// /// Widget principal pour la vue hebdomadaire des quêtes
// /// Implémente une interface gamifiée avec animations et haptiques
// class QuestWeekView extends ConsumerStatefulWidget {
//   final List<DateTime> weekDates;
//
//   const QuestWeekView({
//     super.key,
//     required this.weekDates,
//   });
//
//   @override
//   ConsumerState<QuestWeekView> createState() => _QuestWeekViewState();
// }
//
// class _QuestWeekViewState extends ConsumerState<QuestWeekView>
//     with TickerProviderStateMixin {
//
//   // Controllers
//   final OverlayPortalController _portalController = OverlayPortalController();
//   final ScrollController _scrollController = ScrollController();
//   late AnimationController _fadeController;
//   late AnimationController _scaleController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;
//
//   // State
//   final Map<QuestCellId, GlobalKey> _cellKeys = {};
//   final LayerLink _cellLink = LayerLink();
//   QuestCellId? _hoveredCell;
//   Rect _cellRect = Rect.zero;
//   bool _isOverlayVisible = false;
//
//   // Constants
//   static const Duration _animationDuration = Duration(milliseconds: 300);
//   static const Duration _quickAnimationDuration = Duration(milliseconds: 150);
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _initializeCellKeys();
//   }
//
//   void _initializeAnimations() {
//     _fadeController = AnimationController(
//       vsync: this,
//       duration: _animationDuration,
//     );
//     _scaleController = AnimationController(
//       vsync: this,
//       duration: _quickAnimationDuration,
//     );
//
//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _fadeController,
//       curve: Curves.easeInOutCubic,
//     ));
//
//     _scaleAnimation = Tween<double>(
//       begin: 0.8,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _scaleController,
//       curve: Curves.elasticOut,
//     ));
//   }
//
//   void _initializeCellKeys() {
//     final questCount = ref.read(questMatrixProvider.notifier).questCount;
//     for (int row = 0; row < questCount; row++) {
//       for (int col = 0; col < widget.weekDates.length; col++) {
//         _cellKeys[QuestCellId(row, col)] = GlobalKey();
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _scaleController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _showOverlay(QuestCellId id) async {
//     if (_isOverlayVisible) return;
//
//     final key = _cellKeys[id];
//     final context = key?.currentContext;
//     if (context == null) return;
//
//     final box = context.findRenderObject() as RenderBox?;
//     if (box == null || !box.hasSize) return;
//
//     // Calcul de la position avec gestion des bords d'écran
//     _cellRect = box.localToGlobal(Offset.zero) & box.size;
//
//     // Haptic feedback
//     ref.read(hapticProvider.notifier).impact(HapticFeedbackType.mediumImpact);
//
//     setState(() {
//       _isOverlayVisible = true;
//     });
//
//     // Animation d'entrée
//     ref.read(activeCellProvider.notifier).state = id;
//     _portalController.show();
//
//     await Future.wait([
//       _fadeController.forward(),
//       _scaleController.forward(),
//     ]);
//   }
//
//   Future<void> _removeOverlay() async {
//     if (!_isOverlayVisible) return;
//
//     // Haptic feedback
//     ref.read(hapticProvider.notifier).selection();
//
//     // Animation de sortie
//     await Future.wait([
//       _fadeController.reverse(),
//       _scaleController.reverse(),
//     ]);
//
//     if (mounted) {
//       ref.read(activeCellProvider.notifier).state = null;
//       _portalController.hide();
//
//       setState(() {
//         _isOverlayVisible = false;
//       });
//     }
//   }
//
//   void _onCellHover(QuestCellId? id) {
//     if (_hoveredCell != id) {
//       setState(() {
//         _hoveredCell = id;
//       });
//
//       if (id != null) {
//         ref.read(hapticProvider.notifier).selection();
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final questMatrix = ref.watch(questMatrixProvider);
//     final activeId = ref.watch(activeCellProvider);
//     final theme = Theme.of(context);
//
//     return AnimatedBuilder(
//       animation: _fadeAnimation,
//       builder: (context, child) {
//         return Column(
//           children: [
//             // En-tête avec animation
//             AnimatedContainer(
//               duration: _animationDuration,
//               curve: Curves.easeInOutCubic,
//               child: WeekHeader(dates: widget.weekDates),
//             ),
//
//             // Corps principal
//             Expanded(
//               child: _buildQuestGrid(questMatrix, activeId, theme),
//             ),
//
//             // Overlay portal
//             OverlayPortal(
//               controller: _portalController,
//               overlayChildBuilder: (context) => _buildOverlay(context),
//             ),
//
//             // Pied de page
//             WeekFooter(
//               weekDates: widget.weekDates,
//               totalQuests: questMatrix.length,
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildQuestGrid(Map<QuestCellId, QuestData> questMatrix,
//       QuestCellId? activeId, ThemeData theme) {
//     return NotificationListener<ScrollNotification>(
//       onNotification: (notification) {
//         if (notification is ScrollStartNotification && _isOverlayVisible) {
//           _removeOverlay();
//         }
//         return false;
//       },
//       child: ListView.builder(
//         controller: _scrollController,
//         physics: const BouncingScrollPhysics(),
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         itemCount: ref.read(questMatrixProvider.notifier).questCount,
//         itemBuilder: (context, rowIndex) => _buildQuestRow(
//           rowIndex,
//           activeId,
//           questMatrix,
//           theme,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQuestRow(int rowIndex, QuestCellId? activeId,
//       Map<QuestCellId, QuestData> questMatrix, ThemeData theme) {
//     final questName = ref.read(questMatrixProvider.notifier).getQuestName(rowIndex);
//
//     return AnimatedContainer(
//       duration: _animationDuration,
//       curve: Curves.easeInOutCubic,
//       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Nom de la quête avec indicateur de progression
//           _buildQuestHeader(questName, rowIndex, questMatrix),
//
//           // Grille des cellules
//           _buildCellRow(rowIndex, activeId, questMatrix, theme),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildQuestHeader(String questName, int rowIndex,
//       Map<QuestCellId, QuestData> questMatrix) {
//     final completionRate = _calculateCompletionRate(rowIndex, questMatrix);
//     final level = _calculateQuestLevel(completionRate);
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       child: Row(
//         children: [
//           // Icône de niveau
//           _buildLevelIcon(level),
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
//           // Barre de progression
//           _buildProgressBar(completionRate),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLevelIcon(int level) {
//     return AnimatedContainer(
//       duration: _quickAnimationDuration,
//       width: 24,
//       height: 24,
//       decoration: BoxDecoration(
//         color: _getLevelColor(level),
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: _getLevelColor(level).withOpacity(0.3),
//             blurRadius: 4,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: Center(
//         child: Text(
//           level.toString(),
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 12,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProgressBar(double completion) {
//     return Container(
//       width: 60,
//       height: 8,
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: AnimatedContainer(
//         duration: _animationDuration,
//         curve: Curves.easeInOutCubic,
//         width: 60 * completion,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.blue,
//               Colors.purple,
//             ],
//           ),
//           borderRadius: BorderRadius.circular(4),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCellRow(int rowIndex, QuestCellId? activeId,
//       Map<QuestCellId, QuestData> questMatrix, ThemeData theme) {
//     return SizedBox(
//       height: 80,
//       child: Row(
//         children: List.generate(widget.weekDates.length, (colIndex) {
//           final id = QuestCellId(rowIndex, colIndex);
//           final isToday = DateUtils.isSameDay(
//             widget.weekDates[colIndex],
//             DateTime.now(),
//           );
//           final isActive = id == activeId;
//           final isHovered = id == _hoveredCell;
//           final questData = questMatrix[id];
//
//           return Expanded(
//             key: _cellKeys[id],
//             child: _buildCell(id, isToday, isActive, isHovered, questData),
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget _buildCell(QuestCellId id, bool isToday, bool isActive,
//       bool isHovered, QuestData? questData) {
//     Widget cell = QuestCell(
//       id: id,
//       isActive: isActive,
//       onTap: (_) => _showOverlay(id),
//       onHover: _onCellHover,
//     );
//
//     if (isActive) {
//       cell = CompositedTransformTarget(
//         link: _cellLink,
//         child: cell,
//       );
//     }
//
//     return AnimatedContainer(
//       duration: _quickAnimationDuration,
//       curve: Curves.easeInOutCubic,
//       margin: const EdgeInsets.all(2),
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: isToday
//               ? Colors.blueAccent
//               : isHovered
//               ? Colors.blue.withOpacity(0.3)
//               : Colors.transparent,
//           width: isToday ? 2 : 1,
//         ),
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: isHovered || isActive ? [
//           BoxShadow(
//             color: Colors.blue.withOpacity(0.2),
//             blurRadius: 8,
//             spreadRadius: 2,
//           ),
//         ] : null,
//       ),
//       transform: isHovered && !isActive
//           ? Matrix4.identity()..scale(1.02)
//           : Matrix4.identity(),
//       child: cell,
//     );
//   }
//
//   Widget _buildOverlay(BuildContext context) {
//     final activeId = ref.watch(activeCellProvider);
//     if (activeId == null) return const SizedBox.shrink();
//
//     return AnimatedBuilder(
//       animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
//       builder: (context, child) {
//         return Opacity(
//           opacity: _fadeAnimation.value,
//           child: Transform.scale(
//             scale: _scaleAnimation.value,
//             child: _OverlayHandler(
//               cellLink: _cellLink,
//               activeCellId: activeId,
//               onClose: _removeOverlay,
//               cellRect: _cellRect,
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   // Méthodes utilitaires
//   double _calculateCompletionRate(int rowIndex, Map<QuestCellId, QuestData> questMatrix) {
//     int completed = 0;
//     for (int col = 0; col < widget.weekDates.length; col++) {
//       final data = questMatrix[QuestCellId(rowIndex, col)];
//       if (data?.isCompleted == true) completed++;
//     }
//     return completed / widget.weekDates.length;
//   }
//
//   int _calculateQuestLevel(double completionRate) {
//     return (completionRate * 10).floor() + 1;
//   }
//
//   Color _getLevelColor(int level) {
//     if (level <= 3) return Colors.grey;
//     if (level <= 6) return Colors.blue;
//     if (level <= 8) return Colors.purple;
//     return Colors.gold;
//   }
// }
//
// // --- GESTION AMÉLIORÉE DE L'OVERLAY ---
// class _OverlayHandler extends ConsumerStatefulWidget {
//   final LayerLink cellLink;
//   final QuestCellId activeCellId;
//   final VoidCallback onClose;
//   final Rect cellRect;
//
//   const _OverlayHandler({
//     required this.cellLink,
//     required this.activeCellId,
//     required this.onClose,
//     required this.cellRect,
//   });
//
//   @override
//   ConsumerState<_OverlayHandler> createState() => _OverlayHandlerState();
// }
//
// class _OverlayHandlerState extends ConsumerState<_OverlayHandler>
//     with TickerProviderStateMixin {
//
//   final MenuController _menuController = MenuController();
//   late AnimationController _rippleController;
//   late Animation<double> _rippleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _rippleController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//
//     _rippleAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _rippleController,
//       curve: Curves.easeOutCubic,
//     ));
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         _menuController.open();
//         _rippleController.forward();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _rippleController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Background avec effet de blur
//         Positioned.fill(
//           child: AnimatedBuilder(
//             animation: _rippleAnimation,
//             builder: (context, child) {
//               return GestureDetector(
//                 onTap: widget.onClose,
//                 child: Container(
//                   color: Colors.black.withOpacity(0.6 * _rippleAnimation.value),
//                   child: BackdropFilter(
//                     filter: ImageFilter.blur(
//                       sigmaX: 5 * _rippleAnimation.value,
//                       sigmaY: 5 * _rippleAnimation.value,
//                     ),
//                     child: Container(),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//
//         // Contenu principal
//         CompositedTransformFollower(
//           link: widget.cellLink,
//           targetAnchor: Alignment.center,
//           followerAnchor: Alignment.center,
//           child: MenuAnchor(
//             controller: _menuController,
//             onClose: widget.onClose,
//             style: const MenuStyle(
//               backgroundColor: MaterialStatePropertyAll(Colors.transparent),
//               shadowColor: MaterialStatePropertyAll(Colors.transparent),
//               surfaceTintColor: MaterialStatePropertyAll(Colors.transparent),
//               padding: MaterialStatePropertyAll(EdgeInsets.all(16)),
//             ),
//             menuChildren: [
//               _DockSystem(
//                 id: widget.activeCellId,
//                 closeMenu: widget.onClose,
//                 rippleAnimation: _rippleAnimation,
//               ),
//             ],
//             builder: (context, controller, child) {
//               return SizedBox(
//                 width: widget.cellRect.width,
//                 height: widget.cellRect.height,
//                 child: _HighlightCell(
//                   id: widget.activeCellId,
//                   rippleAnimation: _rippleAnimation,
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // --- CELLULE MISE EN SURBRILLANCE AVEC EFFETS ---
// class _HighlightCell extends ConsumerWidget {
//   final QuestCellId id;
//   final Animation<double> rippleAnimation;
//
//   const _HighlightCell({
//     required this.id,
//     required this.rippleAnimation,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return AnimatedBuilder(
//       animation: rippleAnimation,
//       builder: (context, child) {
//         return Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.white.withOpacity(0.9 * rippleAnimation.value),
//                 blurRadius: 12 + (8 * rippleAnimation.value),
//                 spreadRadius: 8 + (4 * rippleAnimation.value),
//               ),
//               BoxShadow(
//                 color: Colors.blue.withOpacity(0.3 * rippleAnimation.value),
//                 blurRadius: 20,
//                 spreadRadius: 12,
//               ),
//             ],
//           ),
//           child: Transform.scale(
//             scale: 1.0 + (0.1 * rippleAnimation.value),
//             child: QuestCellVisual(
//               id: id,
//               isActive: true,
//               animated: true,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }