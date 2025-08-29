import 'package:freezed_annotation/freezed_annotation.dart';

part 'quest_cell_data.freezed.dart';

@freezed
sealed class QuestCellData with _$QuestCellData {
  const factory QuestCellData({
    String? emoji,
    double? duration,
    @Default(false) bool isCompleted,
  }) = _QuestCellData;
}

// Optionnel : getter personnalisé
extension QuestCellDataX on QuestCellData {
  bool get hasDetails => emoji != null || duration != null;
}