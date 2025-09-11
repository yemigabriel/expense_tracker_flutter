import 'package:expense_tracker/models/expense.dart';

class MonthTotal {
  final DateTime monthStart;
  final String label;
  final double total;
  MonthTotal(this.monthStart, this.label, this.total);
}

List<MonthTotal> buildMonthlyTotals(List<Expense> items, {int months = 6}) {
  const monthsShort = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final now = DateTime.now();
  final firstOfThisMonth = DateTime(now.year, now.month, 1);
  final hasBeforeThisMonth = items.any(
    (e) => e.date.isBefore(firstOfThisMonth),
  );
  final start = hasBeforeThisMonth
      ? DateTime(now.year, now.month - (months - 1), 1)
      : firstOfThisMonth;

  // create empty buckets
  final buckets = <DateTime, double>{};
  for (var i = 0; i < months; i++) {
    final m = DateTime(start.year, start.month + i, 1);
    buckets[m] = 0.0;
  }
  // sum into buckets
  for (final e in items) {
    if (e.date.isBefore(start)) continue;
    final m = DateTime(e.date.year, e.date.month, 1);
    if (buckets.containsKey(m)) {
      buckets[m] = (buckets[m] ?? 0) + e.amount;
    }
  }
  // convert to list
  final keys = buckets.keys.toList()..sort();
  return [
    for (final k in keys)
      MonthTotal(
        k,
        '${monthsShort[k.month - 1]}\'${k.year % 100}',
        buckets[k] ?? 0,
      ),
  ];
}
