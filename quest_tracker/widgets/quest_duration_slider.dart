// lib/quest_tracker/widgets/quest_duration_slider.dart
import 'package:flutter/material.dart';

class QuestDurationSlider extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onSubmitted;

  const QuestDurationSlider({
    super.key,
    required this.initialValue,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<QuestDurationSlider> createState() => _QuestDurationSliderState();
}

class _QuestDurationSliderState extends State<QuestDurationSlider> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = (widget.initialValue / 5).round() * 5;
  }

  String _formatDuration(double minutes) {
    final int mins = minutes.round();
    if (mins == 0) return '0m';
    if (mins < 60) return '${mins}m';
    final int hours = mins ~/ 60;
    final int rest = mins % 60;
    return rest == 0 ? '${hours}h' : '${hours}h${rest.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        showValueIndicator: ShowValueIndicator.always,
      ),
      child: Slider(
        value: _value,
        min: 0,
        max: 180,
        divisions: 36,
        label: _formatDuration(_value),
        onChanged: (v) {
          setState(() => _value = v);
          widget.onChanged?.call(v);
        },
        onChangeEnd: (v) {
          widget.onSubmitted?.call(v);
        },
      ),
    );
  }
}