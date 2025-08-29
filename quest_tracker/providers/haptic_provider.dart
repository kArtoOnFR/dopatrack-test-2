import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hapticProvider = StateNotifierProvider<HapticNotifier, HapticState>((ref) {
  return HapticNotifier();
});

class HapticState {
  final bool isEnabled;
  const HapticState({this.isEnabled = true});
}

class HapticNotifier extends StateNotifier<HapticState> {
  HapticNotifier() : super(const HapticState());

  void impact(HapticFeedbackType type) {
    if (state.isEnabled) {
      switch (type) {
        case HapticFeedbackType.lightImpact:
          HapticFeedback.lightImpact();
          break;
        case HapticFeedbackType.mediumImpact:
          HapticFeedback.mediumImpact();
          break;
        case HapticFeedbackType.heavyImpact:
          HapticFeedback.heavyImpact();
          break;
      }
    }
  }

  void selection() {
    if (state.isEnabled) {
      HapticFeedback.selectionClick();
    }
  }

  void toggleEnabled() {
    state = HapticState(isEnabled: !state.isEnabled);
  }
}

enum HapticFeedbackType {
  lightImpact,
  mediumImpact,
  heavyImpact,
}