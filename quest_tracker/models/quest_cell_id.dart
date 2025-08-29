// lib/quest_tracker/models/quest_cell_id.dart
class QuestCellId {
  final int row;
  final int col;

  const QuestCellId(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is QuestCellId && row == other.row && col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}
