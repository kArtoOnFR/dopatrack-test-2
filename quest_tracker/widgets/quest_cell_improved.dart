import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quest_cell_id.dart';
import '../models/quest_data.dart';
import '../providers/quest_matrix_provider.dart';
import '../providers/quest_matrix_provider_improved.dart';
import '../utils/constants.dart';

class QuestCellImproved extends ConsumerStatefulWidget {
  final QuestCellId id;
  final bool isActive;
  final Function(QuestCellId) onTap;
  final Function(QuestCellId?) onHover;

  const QuestCellImproved({
    super.key,
    required this.id,
    required this.isActive,
    required this.onTap,
    required this.onHover,
  });

  @override
  ConsumerState<QuestCellImproved> createState() => _QuestCellImprovedState();
}

class _QuestCellImprovedState extends ConsumerState<QuestCellImproved>
    with TickerProviderStateMixin {

  late AnimationController _pulseController;
  late AnimationController _completeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  bool _isHovered = false;
  bool _wasCompleted = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _completeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _completeController,
      curve: Curves.elasticOut,
    ));

    _colorAnimation = ColorTween(
      begin: Colors.grey[300],
      end: Colors.green,
    ).animate(CurvedAnimation(
      parent: _completeController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _completeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questData = ref.watch(questMatrixProvider)[widget.id];
    final isCompleted = questData?.isCompleted ?? false;

    // Animation de completion
    if (isCompleted && !_wasCompleted) {
      _wasCompleted = true;
      _completeController.forward();
      HapticFeedback.heavyImpact();
    } else if (!isCompleted && _wasCompleted) {
      _wasCompleted = false;
      _completeController.reverse();
    }

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        widget.onHover(widget.id);
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        widget.onHover(null);
      },
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          widget.onTap(widget.id);
        },
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _pulseAnimation,
            _scaleAnimation,
            _colorAnimation,
          ]),
          builder: (context, child) {
            return Transform.scale(
              scale: _isHovered ? 1.02 : 1.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: _buildGradient(questData),
                  boxShadow: _buildShadow(isCompleted),
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => widget.onTap(widget.id),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: _buildContent(questData, isCompleted),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  LinearGradient _buildGradient(QuestData? questData) {
    if (questData?.isCompleted == true) {
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

  List<BoxShadow> _buildShadow(bool isCompleted) {
    if (isCompleted) {
      return [
        BoxShadow(
          color: Colors.green.withOpacity(0.3),
          blurRadius: 12,
          spreadRadius: 2,
        ),
      ];
    }

    if (_isHovered || widget.isActive) {
      return [
        BoxShadow(
          color: Colors.blue.withOpacity(0.2),
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ];
    }

    return [];
  }

  Widget _buildContent(QuestData? questData, bool isCompleted) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Emoji ou icône
        if (questData?.emoji != null) ...[
          Text(
            questData!.emoji!,
            style: TextStyle(
              fontSize: isCompleted ? 32 : 24,
            ),
          ),
        ] else if (isCompleted) ...[
          const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 32,
          ),
        ],

        // Durée si définie
        if (questData?.duration != null) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${questData!.duration!.round()}min',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],

        // Indicateur de série
        if (questData?.streak != null && questData!.streak > 0) ...[
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_fire_department,
                color: Colors.orange,
                size: 12,
              ),
              Text(
                questData.streak.toString(),
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}