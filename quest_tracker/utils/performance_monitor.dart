import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import 'error_handling.dart';

class PerformanceMonitor {
  static final Map<String, Stopwatch> _stopwatches = {};
  static final List<FrameTiming> _frameTimings = [];
  static bool _isMonitoring = false;

  static void startMonitoring() {
    if (_isMonitoring) return;

    _isMonitoring = true;
    SchedulerBinding.instance.addTimingsCallback(_onFrameTiming);
  }

  static void stopMonitoring() {
    if (!_isMonitoring) return;

    _isMonitoring = false;
    SchedulerBinding.instance.removeTimingsCallback(_onFrameTiming);
  }

  static void startTimer(String name) {
    _stopwatches[name] = Stopwatch()..start();
  }

  static void endTimer(String name) {
    final stopwatch = _stopwatches.remove(name);
    if (stopwatch != null) {
      final duration = stopwatch.elapsedMilliseconds;
      if (kDebugMode) {
        print('⏱️ $name: ${duration}ms');
      }

      if (duration > 16) { // > 16ms = potential jank
        QuestErrorHandler.logWarning('Potential jank detected in $name: ${duration}ms');
      }
    }
  }

  static void _onFrameTiming(List<FrameTiming> timings) {
    _frameTimings.addAll(timings);

    // Keep only last 60 frames
    if (_frameTimings.length > 60) {
      _frameTimings.removeRange(0, _frameTimings.length - 60);
    }

    // Check for jank
    for (final timing in timings) {
      final frameDuration = timing.totalSpan.inMicroseconds / 1000; // Convert to milliseconds
      if (frameDuration > 16.67) { // 60fps = 16.67ms per frame
        QuestErrorHandler.logWarning('Frame jank detected: ${frameDuration.toStringAsFixed(2)}ms');
      }
    }
  }

  static double get averageFrameTime {
    if (_frameTimings.isEmpty) return 0;

    final totalTime = _frameTimings
        .map((timing) => timing.totalSpan.inMicroseconds)
        .reduce((a, b) => a + b);

    return (totalTime / _frameTimings.length) / 1000; // Convert to milliseconds
  }

  static int get droppedFrames {
    return _frameTimings.where((timing) =>
    timing.totalSpan.inMicroseconds > 16670 // > 16.67ms
    ).length;
  }
}