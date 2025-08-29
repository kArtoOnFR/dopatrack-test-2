// lib/quest_tracker/widgets/week_header.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekHeader extends StatelessWidget {
  final List<DateTime> dates;

  const WeekHeader({super.key, required this.dates});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE\ndd/MM', 'fr_FR');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      color: Colors.grey[200],
      child: Row(
        children: dates.map((date) {
          final isToday = DateUtils.isSameDay(date, DateTime.now());
          return Expanded(
            child: Column(
              children: [
                Text(
                  dateFormat.format(date),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isToday ? Colors.blue : Colors.black87,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
