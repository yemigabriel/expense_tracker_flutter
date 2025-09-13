import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class InsightsViewModel extends ChangeNotifier {
  List<Expense> _expenses = const [];
  String _currencyCode = 'USD';
  late NumberFormat moneyFmt = NumberFormat.currency(name: _currencyCode);

  final now = DateTime.now();
  DateTime _startOfMonth(DateTime d) => DateTime(d.year, d.month, 1);

  void update({required List<Expense> expenses, required String currencyCode}) {
    _expenses = List<Expense>.of(expenses);
    if (_currencyCode != currencyCode) {
      _currencyCode = currencyCode;
      moneyFmt = NumberFormat.currency(name: _currencyCode);
    }
    notifyListeners();
  }

  double monthTotal() {
    final start = _startOfMonth(now);
    return _expenses
        .where(
          (e) =>
              !e.date.isBefore(start) &&
              e.date.isBefore(now.add(const Duration(days: 1))),
        )
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double lastMonthTotal() {
    final start = _startOfMonth(DateTime(now.year, now.month - 1, 1));
    final end = _startOfMonth(now);
    return _expenses
        .where((e) => !e.date.isBefore(start) && e.date.isBefore(end))
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  ({String category, double percentage}) biggestCategoryThisMonth() {
    final start = _startOfMonth(now);
    final map = <String, double>{};
    for (final e in _expenses) {
      if (e.date.isBefore(start)) continue;
      map[e.category.name] = (map[e.category.name] ?? 0) + e.amount;
    }
    if (map.isEmpty) return (category: '—', percentage: 0);
    final total = map.values.fold(0.0, (s, v) => s + v);
    final top = map.entries.reduce((a, b) => a.value >= b.value ? a : b);
    return (
      category: top.key,
      percentage: total == 0 ? 0 : (top.value / total) * 100,
    );
  }

  ({DateTime day, double total}) mostExpensiveDayThisMonth() {
    final start = _startOfMonth(now);
    final byDay = <DateTime, double>{};
    for (final e in _expenses) {
      if (e.date.isBefore(start)) continue;
      final d = DateTime(e.date.year, e.date.month, e.date.day);
      byDay[d] = (byDay[d] ?? 0) + e.amount;
    }
    if (byDay.isEmpty) return (day: start, total: 0);
    final top = byDay.entries.reduce((a, b) => a.value >= b.value ? a : b);
    return (day: top.key, total: top.value);
  }

  int noSpendDaysThisMonth() {
    final start = _startOfMonth(now);
    final today = DateTime(now.year, now.month, now.day);
    final elapsed = now.day; // days 1..today
    final spentDays = <DateTime>{};
    for (final e in _expenses) {
      if (e.date.isBefore(start) || e.date.isAfter(today)) continue;
      spentDays.add(DateTime(e.date.year, e.date.month, e.date.day));
    }
    return elapsed - spentDays.length;
  }
}
