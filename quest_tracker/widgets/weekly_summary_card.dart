import 'package:dopatrack/quest_tracker/widgets/xp_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/gamification_provider.dart';
import '../providers/quest_matrix_provider.dart';
import '../providers/quest_matrix_provider_improved.dart';
import '../utils/constants.dart';
import 'animated_counter.dart';

class WeeklySummaryCard extends ConsumerWidget {
  final List<DateTime> weekDates;

  const WeeklySummaryCard({
    super.key,
    required this.weekDates,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(questMatrixProvider.notifier).getWeeklyStats(weekDates.length);
    final gamificationState = ref.watch(gamificationProvider);

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: QuestConstants.questGradient,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // En-tête
            const Row(
              children: [
                Icon(Icons.analytics, color: Colors.white, size: 24),
                SizedBox(width: 8),
                Text(
                  'Résumé Hebdomadaire',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Statistiques principales
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Complétées',
                    value: stats['completed']!,
                    total: stats['possible']!,
                    icon: Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Série Max',
                    value: stats['longest_streak']!,
                    icon: Icons.local_fire_department,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Barre de progression XP
            XPBar(
              currentXP: gamificationState.currentLevelXP,
              maxXP: gamificationState.nextLevelXP,
              level: gamificationState.level,
            ),
            const SizedBox(height: 16),

            // Pourcentage de completion
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: stats['percentage']! / 100),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutQuart,
              builder: (context, value, child) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              '${stats['percentage']}% Complété',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int value;
  final int? total;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    this.total,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          AnimatedCounter(
            value: value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (total != null) ...[
            Text(
              '/$total',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}