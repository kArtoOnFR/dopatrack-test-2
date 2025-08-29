import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quest_cell_id.dart';
import '../models/quest_data.dart';
import '../providers/quest_matrix_provider.dart';
import '../providers/quest_matrix_provider_improved.dart';
import '../utils/constants.dart';
import 'animated_counter.dart';

class PerformanceOptimizedGrid extends ConsumerWidget {
  final List<DateTime> weekDates;
  final QuestCellId? activeId;
  final Function(QuestCellId) onCellTap;
  final Function(QuestCellId?) onCellHover;

  const PerformanceOptimizedGrid({
    super.key,
    required this.weekDates,
    this.activeId,
    required this.onCellTap,
    required this.onCellHover,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questMatrix = ref.watch(questMatrixProvider);
    final questCount = ref.read(questMatrixProvider.notifier).questCount;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverList.builder(
          itemCount: questCount,
          itemBuilder: (context, rowIndex) {
            return RepaintBoundary(
              child: _QuestRowOptimized(
                rowIndex: rowIndex,
                weekDates: weekDates,
                activeId: activeId,
                questMatrix: questMatrix,
                onCellTap: onCellTap,
                onCellHover: onCellHover,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _QuestRowOptimized extends ConsumerWidget {
  final int rowIndex;
  final List<DateTime> weekDates;
  final QuestCellId? activeId;
  final Map<QuestCellId, QuestData> questMatrix;
  final Function(QuestCellId) onCellTap;
  final Function(QuestCellId?) onCellHover;

  const _QuestRowOptimized({
    required this.rowIndex,
    required this.weekDates,
    this.activeId,
    required this.questMatrix,
    required this.onCellTap,
    required this.onCellHover,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questName = ref.read(questMatrixProvider.notifier).getQuestName(rowIndex);
    final completionRate = ref.read(questMatrixProvider.notifier)
        .getQuestCompletionRate(rowIndex, weekDates.length);

    return AnimatedContainer(
      duration: QuestConstants.fastAnimation,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _QuestHeader(
            questName: questName,
            completionRate: completionRate,
          ),
          SizedBox(
            height: QuestConstants.cellHeight,
            child: Row(
              children: List.generate(weekDates.length, (colIndex) {
                final id = QuestCellId(rowIndex, colIndex);
                return Expanded(
                  child: _OptimizedQuestCell(
                    id: id,
                    isToday: DateUtils.isSameDay(weekDates[colIndex], DateTime.now()),
                    isActive: id == activeId,
                    questData: questMatrix[id],
                    onTap: onCellTap,
                    onHover: onCellHover,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestHeader extends StatelessWidget {
  final String questName;
  final double completionRate;

  const _QuestHeader({
    required this.questName,
    required this.completionRate,
  });

  @override
  Widget build(BuildContext context) {
    final level = (completionRate * 10).floor() + 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          // Icône de niveau avec animation
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: completionRate),
            duration: QuestConstants.mediumAnimation,
            builder: (context, value, child) {
              return Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _getLevelColor(level),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _getLevelColor(level).withOpacity(0.3),
                      blurRadius: 4 * value,
                      spreadRadius: 1 * value,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    level.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),

          // Nom de la quête
          Expanded(
            child: Text(
              questName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),

          // Barre de progression animée
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: completionRate),
            duration: QuestConstants.mediumAnimation,
            curve: Curves.easeOutQuart,
            builder: (context, value, child) {
              return Container(
                width: 60,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Stack(
                  children: [
                    Container(
                      width: 60 * value,
                      decoration: BoxDecoration(
                        gradient: QuestConstants.levelGradient,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: value > 0.5 ? [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.3),
                            blurRadius: 4,
                          ),
                        ] : null,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getLevelColor(int level) {
    if (level <= 3) return Colors.grey;
    if (level <= 6) return Colors.blue;
    if (level <= 8) return Colors.purple;
    return QuestConstants.primaryGold;
  }
}

class _OptimizedQuestCell extends StatefulWidget {
  final QuestCellId id;
  final bool isToday;
  final bool isActive;
  final QuestData? questData;
  final Function(QuestCellId) onTap;
  final Function(QuestCellId?) onHover;

  const _OptimizedQuestCell({
    required this.id,
    required this.isToday,
    required this.isActive,
    this.questData,
    required this.onTap,
    required this.onHover,
  });

  @override
  State<_OptimizedQuestCell> createState() => _OptimizedQuestCellState();
}

class _OptimizedQuestCellState extends State<_OptimizedQuestCell>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: QuestConstants.fastAnimation,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool isHovered) {
    if (_isHovered != isHovered) {
      setState(() {
        _isHovered = isHovered;
      });

      if (isHovered) {
        _animationController.forward();
        widget.onHover(widget.id);
      } else {
        _animationController.reverse();
        widget.onHover(null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final isCompleted = widget.questData?.isCompleted ?? false;

    return MouseRegion(
      onEnter: (_) => _onHoverChanged(true),
      onExit: (_) => _onHoverChanged(false),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: widget.isToday
                      ? Colors.blueAccent
                      : _isHovered || widget.isActive
                      ? Colors.blue.withOpacity(0.5)
                      : Colors.transparent,
                  width: widget.isToday ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: (_isHovered || widget.isActive) ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ] : null,
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => widget.onTap(widget.id),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: _buildGradient(isCompleted),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: _buildCellContent(isCompleted),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  LinearGradient _buildGradient(bool isCompleted) {
    if (isCompleted) {
      return QuestConstants.completedGradient;
    }

    if (_isHovered || widget.isActive) {
      return QuestConstants.questGradient;
    }

    return LinearGradient(
      colors: [
        Colors.grey[100]!,
        Colors.grey[200]!,
      ],
    );
  }

  Widget _buildCellContent(bool isCompleted) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Contenu principal
        if (widget.questData?.emoji != null) ...[
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: isCompleted ? 1.2 : 1.0),
            duration: QuestConstants.mediumAnimation,
            curve: Curves.elasticOut,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Text(
                  widget.questData!.emoji!,
                  style: const TextStyle(fontSize: 24),
                ),
              );
            },
          ),
        ] else if (isCompleted) ...[
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: QuestConstants.mediumAnimation,
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 28,
                ),
              );
            },
          ),
        ],

        // Informations secondaires
        if (widget.questData?.duration != null) ...[
          const SizedBox(height: 4),
          _buildDurationChip(),
        ],

        // Indicateur de série
        if (widget.questData?.streak != null && widget.questData!.streak > 0) ...[
          const SizedBox(height: 2),
          _buildStreakIndicator(),
        ],
      ],
    );
  }

  Widget _buildDurationChip() {
    return AnimatedContainer(
      duration: QuestConstants.fastAnimation,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${widget.questData!.duration!.round()}min',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStreakIndicator() {
    return AnimatedContainer(
      duration: QuestConstants.fastAnimation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: QuestConstants.mediumAnimation,
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: const Icon(
                  Icons.local_fire_department,
                  color: Colors.orange,
                  size: 12,
                ),
              );
            },
          ),
          const SizedBox(width: 2),
          AnimatedCounter(
            value: widget.questData!.streak,
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            duration: QuestConstants.fastAnimation,
          ),
        ],
      ),
    );
  }
}