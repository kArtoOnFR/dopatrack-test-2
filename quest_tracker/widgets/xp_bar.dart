import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'animated_counter.dart';

class XPBar extends StatefulWidget {
  final int currentXP;
  final int maxXP;
  final int level;

  const XPBar({
    super.key,
    required this.currentXP,
    required this.maxXP,
    required this.level,
  });

  @override
  State<XPBar> createState() => _XPBarState();
}

class _XPBarState extends State<XPBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fillAnimation = Tween<double>(
      begin: 0,
      end: widget.currentXP / widget.maxXP,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(XPBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentXP != widget.currentXP) {
      _fillAnimation = Tween<double>(
        begin: oldWidget.currentXP / oldWidget.maxXP,
        end: widget.currentXP / widget.maxXP,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutQuart,
      ));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[300],
      ),
      child: Stack(
        children: [
          // Barre de fond
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[300],
            ),
          ),

          // Barre de progression animée
          AnimatedBuilder(
            animation: _fillAnimation,
            builder: (context, child) {
              return Container(
                width: MediaQuery.of(context).size.width * _fillAnimation.value,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: QuestConstants.levelGradient,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              );
            },
          ),

          // Texte centré
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Niveau ${widget.level}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedCounter(
                  value: widget.currentXP,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '/${widget.maxXP} XP',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
