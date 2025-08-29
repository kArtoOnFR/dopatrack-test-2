import 'package:flutter/material.dart';
import 'quest_week_view.dart';

class QuestCalendarPageView extends StatelessWidget {
  const QuestCalendarPageView({
    super.key,
    required this.weeksPerPage,
    required this.initialPage,
  });

  final int weeksPerPage;
  final int initialPage;

  static const int weeksBefore = 2;
  static const int weeksAfter = 2;

  List<DateTime> _daysForPage(int pageIndex) {
    final today = DateTime.now();
    final totalDays = weeksPerPage * 7;
    final centerOffset = totalDays ~/ 2;

    final startOfPage = today.subtract(Duration(days: centerOffset))
        .add(Duration(days: (pageIndex - initialPage) * totalDays));

    return List.generate(totalDays, (i) => startOfPage.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = weeksBefore + 1 + weeksAfter;

    return PageView.builder(
      controller: PageController(initialPage: initialPage),
      itemCount: totalPages,
      itemBuilder: (context, pageIndex) {
        final days = _daysForPage(pageIndex);
        return QuestWeekView(weekDates: days);
      },
    );
  }
}
