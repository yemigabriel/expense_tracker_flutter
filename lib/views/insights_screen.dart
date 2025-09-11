import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/view_model/expenses_view_model.dart';
import 'package:expense_tracker/views/charts_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenses = context.watch<ExpensesViewModel>().expenses;
    final now = DateTime.now();

    final mtd = monthTotal(expenses, now);
    final big = biggestCategoryThisMonth(expenses, now);
    final maxD = mostExpensiveDayThisMonth(expenses, now);
    final noSpend = noSpendDaysThisMonth(expenses, now);

    Widget card(String title, String value, {Color? color, String? sub}) =>
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color ?? Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 6),
              Text(value, style: Theme.of(context).textTheme.titleLarge),
              if (sub != null) ...[
                const SizedBox(height: 4),
                Text(sub, style: Theme.of(context).textTheme.bodySmall),
              ],
            ],
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Insights',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 20,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  card('Monthly Total', mtd.toStringAsFixed(2)),
                  card(
                    'Biggest Category',
                    big.category,
                    sub: '${big.sharePct.toStringAsFixed(0)}% share',
                  ),
                  card(
                    'Most Expensive Day',
                    '${maxD.total.toStringAsFixed(2)}',
                    sub: '${maxD.day.toLocal().toString().split(' ').first}',
                  ),
                  card('No-Spend Days', '$noSpend'),
                ],
              ),
              const SizedBox(height: 25),
              ChartsScreen(),
            ],
          ),
        ),
      ),
    );
  }
}

DateTime _startOfMonth(DateTime d) => DateTime(d.year, d.month, 1);
int _daysInMonth(DateTime d) => DateTime(d.year, d.month + 1, 0).day;

double monthTotal(List<Expense> xs, DateTime now) {
  final start = _startOfMonth(now);
  return xs
      .where(
        (e) =>
            !e.date.isBefore(start) &&
            e.date.isBefore(now.add(const Duration(days: 1))),
      )
      .fold(0.0, (sum, e) => sum + e.amount);
}

double lastMonthTotal(List<Expense> xs, DateTime now) {
  final start = _startOfMonth(DateTime(now.year, now.month - 1, 1));
  final end = _startOfMonth(now);
  return xs
      .where((e) => !e.date.isBefore(start) && e.date.isBefore(end))
      .fold(0.0, (sum, e) => sum + e.amount);
}

double projectedMonthTotal(List<Expense> xs, DateTime now) {
  final mtd = monthTotal(xs, now);
  final elapsed = now.day.clamp(1, _daysInMonth(now));
  final totalDays = _daysInMonth(now);
  return (mtd / elapsed) * totalDays;
}

({String category, double sharePct}) biggestCategoryThisMonth(
  List<Expense> xs,
  DateTime now,
) {
  final start = _startOfMonth(now);
  final map = <String, double>{};
  for (final e in xs) {
    if (e.date.isBefore(start)) continue;
    map[e.category.name] = (map[e.category.name] ?? 0) + e.amount;
  }
  if (map.isEmpty) return (category: '—', sharePct: 0);
  final total = map.values.fold(0.0, (s, v) => s + v);
  final top = map.entries.reduce((a, b) => a.value >= b.value ? a : b);
  return (
    category: top.key,
    sharePct: total == 0 ? 0 : (top.value / total) * 100,
  );
}

({DateTime day, double total}) mostExpensiveDayThisMonth(
  List<Expense> xs,
  DateTime now,
) {
  final start = _startOfMonth(now);
  final byDay = <DateTime, double>{};
  for (final e in xs) {
    if (e.date.isBefore(start)) continue;
    final d = DateTime(e.date.year, e.date.month, e.date.day);
    byDay[d] = (byDay[d] ?? 0) + e.amount;
  }
  if (byDay.isEmpty) return (day: start, total: 0);
  final top = byDay.entries.reduce((a, b) => a.value >= b.value ? a : b);
  return (day: top.key, total: top.value);
}

int noSpendDaysThisMonth(List<Expense> xs, DateTime now) {
  final start = _startOfMonth(now);
  final today = DateTime(now.year, now.month, now.day);
  final totalDays = _daysInMonth(now);
  final elapsed = now.day; // days 1..today
  final spentDays = <DateTime>{};
  for (final e in xs) {
    if (e.date.isBefore(start) || e.date.isAfter(today)) continue;
    spentDays.add(DateTime(e.date.year, e.date.month, e.date.day));
  }
  return elapsed - spentDays.length;
}
