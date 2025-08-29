import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quest_cell_id.dart';

final activeCellProvider = StateProvider<QuestCellId?>((ref) => null);
