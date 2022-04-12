import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogItem {
  final String text;

  LogItem({this.text = ""});
}

class LogNotifier extends StateNotifier<List<LogItem>> {
  LogNotifier() : super([]);
  void addItem(LogItem item) {
    state = [...state, item];
  }
}

final logProvider = StateNotifierProvider<LogNotifier, List<LogItem>>(
  (_) => LogNotifier(),
);
