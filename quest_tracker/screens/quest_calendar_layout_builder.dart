// lib/quest_tracker/screens/quest_calendar_layout_builder.dart
import 'package:flutter/material.dart';
import 'quest_calendar_page.dart';

enum DeviceSize { mobile, tablet, desktop }

class QuestCalendarLayoutBuilder extends StatelessWidget {
  const QuestCalendarLayoutBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final device = width >= 1200
            ? DeviceSize.desktop
            : (width >= 700 ? DeviceSize.tablet : DeviceSize.mobile);

        final weeksPerPage = switch (device) {
          DeviceSize.desktop => 4,
          DeviceSize.tablet => 2,
          DeviceSize.mobile => 1,
        };

        final initialPage = switch (device) {
          DeviceSize.desktop => 1,
          _ => 2,
        };

        return QuestCalendarPageView(
          weeksPerPage: weeksPerPage,
          initialPage: initialPage,
        );
      },
    );
  }
}
