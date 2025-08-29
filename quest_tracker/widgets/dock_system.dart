import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quest_cell_id.dart';
import '../providers/haptic_provider.dart';
import '../providers/quest_matrix_provider_improved.dart';

enum DockAction { none, emoji, duration, streak, notes }

class DockSystem extends ConsumerStatefulWidget {
  final QuestCellId id;
  final VoidCallback closeMenu;
  final Animation<double> rippleAnimation;

  const DockSystem({
    required this.id,
    required this.closeMenu,
    required this.rippleAnimation,
  });

  @override
  ConsumerState<DockSystem> createState() => _DockSystemState();
}

class _DockSystemState extends ConsumerState<DockSystem>
    with TickerProviderStateMixin {

  DockAction _openDockAction = DockAction.none;
  late AnimationController _dockController;
  late AnimationController _menuController;
  late List<AnimationController> _fabControllers;
  late List<Animation<double>> _fabAnimations;
  late Animation<double> _dockAnimation;

  static const Duration _staggerDelay = Duration(milliseconds: 80);
  static const List<DockAction> _dockActions = [
    DockAction.emoji,
    DockAction.duration,
    DockAction.streak,
    DockAction.notes,
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startStaggeredAnimation();
  }

  void _initializeAnimations() {
    _dockController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _dockAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _dockController,
      curve: Curves.elasticOut,
    ));

    // Animations individuelles pour chaque FAB
    _fabControllers = List.generate(_dockActions.length + 1, (index) =>
        AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 300 + (index * 50)),
        )
    );

    _fabAnimations = _fabControllers.map((controller) =>
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.elasticOut,
          ),
        )
    ).toList();
  }

  Future<void> _startStaggeredAnimation() async {
    await _dockController.forward();

    for (int i = 0; i < _fabControllers.length; i++) {
      _fabControllers[i].forward();
      if (i < _fabControllers.length - 1) {
        await Future.delayed(_staggerDelay);
      }
    }
  }

  @override
  void dispose() {
    _dockController.dispose();
    _menuController.dispose();
    for (final controller in _fabControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _toggleMenu(DockAction action) async {
    // Haptic feedback
    ref.read(hapticProvider.notifier).impact(HapticFeedbackType.lightImpact);

    if (_openDockAction == action) {
      await _menuController.reverse();
      setState(() {
        _openDockAction = DockAction.none;
      });
    } else {
      if (_openDockAction != DockAction.none) {
        await _menuController.reverse();
      }

      setState(() {
        _openDockAction = action;
      });

      await _menuController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_dockAnimation, widget.rippleAnimation]),
      builder: (context, child) {

        final ripple = widget.rippleAnimation.value.clamp(0.0, 1.0).toDouble();
        final dockScale = _dockAnimation.value.clamp(0.0, 1.0).toDouble();

        return Opacity(
          opacity: ripple,
          child: Transform.scale(
            scale: dockScale,
            child: _buildDockLayout(),
          ),
        );
      },
    );
  }

  Widget _buildDockLayout() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Menu gauche
        if (_openDockAction == DockAction.emoji) ...[
          _buildAnimatedMenu(_buildEmojiMenu()),
          const SizedBox(width: 12),
        ],
        if (_openDockAction == DockAction.notes) ...[
          _buildAnimatedMenu(_buildNotesMenu()),
          const SizedBox(width: 12),
        ],

        // Dock central
        _buildMainDock(),

        // Menu droite
        if (_openDockAction == DockAction.duration) ...[
          const SizedBox(width: 12),
          _buildAnimatedMenu(_buildDurationMenu()),
        ],
        if (_openDockAction == DockAction.streak) ...[
          const SizedBox(width: 12),
          _buildAnimatedMenu(_buildStreakMenu()),
        ],
      ],
    );
  }

  Widget _buildAnimatedMenu(Widget menu) {
    return AnimatedBuilder(
      animation: _menuController,
      builder: (context, child) {
        final t = _menuController.value.clamp(0.0, 1.0).toDouble();

        return Transform.scale(
          scale: t,
          child: Opacity(
            opacity: _menuController.value,
            child: menu,
          ),
        );
      },
    );
  }

  Widget _buildMainDock() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._dockActions.asMap().entries.map((entry) {
            final index = entry.key;
            final action = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _buildAnimatedFab(action, index),
            );
          }),
          _buildAnimatedResetFab(_dockActions.length),
        ],
      ),
    );
  }

  Widget _buildAnimatedFab(DockAction action, int index) {
    return AnimatedBuilder(
      animation: _fabAnimations[index],
      builder: (context, child) {
        final t = _fabAnimations[index].value.clamp(0.0, 1.0).toDouble();

        return Transform.scale(
          scale: t,
          child: Opacity(
            opacity: t,
            child: _buildFab(action),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedResetFab(int index) {
    return AnimatedBuilder(
      animation: _fabAnimations[index],
      builder: (context, child) {
        final t = _fabAnimations[index].value.clamp(0.0, 1.0).toDouble();

        return Transform.scale(
          scale: t,
          child: Opacity(
            opacity: t,
            child: _buildResetFab(),
          ),
        );
      },
    );
  }

  Widget _buildFab(DockAction action) {
    final questData = ref.watch(questMatrixProvider)[widget.id];
    final isActive = _openDockAction == action;

    IconData? icon;
    Widget? customChild;
    Color activeColor = Colors.grey; // <- défaut, plus besoin de !

    switch (action) {
      case DockAction.emoji:
        if (questData?.emoji != null) {
          customChild = Text(
            questData!.emoji!,
            style: const TextStyle(fontSize: 20),
          );
        } else {
          icon = Icons.emoji_emotions_outlined;
        }
        activeColor = Colors.orange;
        break;
      case DockAction.duration:
        icon = Icons.timer_outlined;
        activeColor = Colors.blue;
        break;
      case DockAction.streak:
        icon = Icons.local_fire_department_outlined;
        activeColor = Colors.red;
        break;
      case DockAction.notes:
        icon = Icons.note_outlined;
        activeColor = Colors.green;
        break;
      default:
        icon = Icons.help_outline;
        activeColor = Colors.grey;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOutCubic,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? activeColor.withOpacity(0.1)
            : Colors.transparent,
        border: isActive
            ? Border.all(color: activeColor, width: 2)
            : null,
      ),
      child: Material(
        color: isActive
            ? activeColor.withOpacity(0.1)
            : Colors.white,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        elevation: isActive ? 4 : 0,
        child: InkWell(
          onTap: () => _toggleMenu(action),
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: customChild ?? Icon(
                icon,
                size: 22,
                color: isActive ? activeColor : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetFab() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        child: InkWell(
          onTap: () async {
            // Haptic feedback fort
            ref.read(hapticProvider.notifier).impact(HapticFeedbackType.heavyImpact);

            // Animation de suppression
            await _showResetAnimation();

            ref.read(questMatrixProvider.notifier).reset(widget.id);
            widget.closeMenu();
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 48,
            height: 48,
            child: const Icon(
              Icons.restart_alt,
              size: 22,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showResetAnimation() async {
    // Animation de "shake" pour confirmer la suppression
    final shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    final shakeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: shakeController,
      curve: Curves.elasticInOut,
    ));

    await shakeController.forward();
    shakeController.dispose();
  }

  Widget _buildEmojiMenu() {
    final emojis = [
      '😊', '🎯', '💪', '🔥', '⭐', '✅',
      '🚀', '💎', '🎪', '🌟', '⚡', '🎨',
      '🏆', '🎵', '🌈', '🦄', '👑', '🎭'
    ];

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 12,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🎨 Choisis ton emoji',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: emojis.map((emoji) {
                return _buildEmojiButton(emoji);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiButton(String emoji) {
    return Material(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () async {
          // Haptic feedback
          ref.read(hapticProvider.notifier).impact(HapticFeedbackType.mediumImpact);

          // Animation de sélection
          await _animateSelection();

          ref.read(questMatrixProvider.notifier).setEmoji(widget.id, emoji);
          _toggleMenu(DockAction.duration); // Transition vers le menu suivant
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDurationMenu() {
    final duration = ref.watch(questMatrixProvider.select((m) => m[widget.id]?.duration)) ?? 30.0;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 12,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.timer, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Durée de la quête',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${duration.round()} min',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 6,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
                activeTrackColor: Colors.blue,
                inactiveTrackColor: Colors.grey[300],
                thumbColor: Colors.blue,
                overlayColor: Colors.blue.withOpacity(0.2),
              ),
              child: Slider(
                value: duration,
                min: 5,
                max: 120,
                divisions: 23,
                onChanged: (value) {
                  ref.read(hapticProvider.notifier).selection();
                  ref.read(questMatrixProvider.notifier).setDuration(widget.id, value);
                },
                onChangeEnd: (value) {
                  ref.read(hapticProvider.notifier).impact(HapticFeedbackType.lightImpact);
                  widget.closeMenu();
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('5 min', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                Text('2h', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakMenu() {
    final questData = ref.watch(questMatrixProvider)[widget.id];
    final currentStreak = questData?.streak ?? 0;
    final totalCompleted = _calculateTotalCompleted();

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 12,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              children: [
                Icon(Icons.local_fire_department, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Statistiques',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatCard('🔥 Série actuelle', currentStreak.toString(), Colors.red),
            const SizedBox(height: 8),
            _buildStatCard('✅ Total complété', totalCompleted.toString(), Colors.green),
            const SizedBox(height: 8),
            _buildStatCard('🏆 Niveau', _calculateLevel(totalCompleted).toString(), Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesMenu() {
    final questData = ref.watch(questMatrixProvider)[widget.id];
    final controller = TextEditingController(text: questData?.notes ?? '');

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 12,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              children: [
                Icon(Icons.note, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Notes de quête',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Ajoute tes notes...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
              onChanged: (value) {
                ref.read(questMatrixProvider.notifier).setNotes(widget.id, value);
              },
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    controller.clear();
                    ref.read(questMatrixProvider.notifier).setNotes(widget.id, '');
                  },
                  child: const Text('Effacer'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: widget.closeMenu,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('OK'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _animateSelection() async {
    // Animation de feedback lors de la sélection
    final selectionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    await selectionController.forward();
    selectionController.dispose();
  }

  int _calculateTotalCompleted() {
    // Logique pour calculer le total de quêtes complétées
    final matrix = ref.read(questMatrixProvider);
    return matrix.values.where((data) => data.isCompleted).length;
  }

  int _calculateLevel(int totalCompleted) {
    // Système de niveau basé sur le nombre total de quêtes complétées
    return (totalCompleted ~/ 10) + 1;
  }
}

// --- PROV