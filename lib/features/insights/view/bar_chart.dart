import 'dart:math' as math;
import 'package:expense_tracker/models/bar_chart_data.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyTotalsBarChart extends StatelessWidget {
  final List<Expense> expenses;
  final int months;
  const MonthlyTotalsBarChart({
    super.key,
    required this.expenses,
    this.months = 5,
  });

  @override
  Widget build(BuildContext context) {
    final data = buildMonthlyTotals(expenses, months: months);
    if (data.isEmpty) return const Center(child: Text('No expenses yet'));

    final maxY = data.fold<double>(0, (s, e) => math.max(s, e.total));
    final interval = _niceInterval(maxY);

    return SizedBox(
      height: 260,
      child: BarChart(
        BarChartData(
          gridData: FlGridData(
            show: false,
            drawVerticalLine: false,
            horizontalInterval: interval,
          ),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, gi, rod, ri) {
                final i = group.x.toInt();
                final m = data[i];
                return BarTooltipItem(
                  '${m.label}\n${rod.toY.toStringAsFixed(2)}',
                  const TextStyle(fontWeight: FontWeight.w600),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                maxIncluded: false,
                showTitles: true,
                reservedSize: 42,
                interval: interval,
                getTitlesWidget: (v, meta) => Text(
                  _shortNumber(v),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, meta) {
                  final i = v.toInt();
                  if (i < 0 || i >= data.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      data[i].label,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: List.generate(data.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: data[i].total,
                  width: 22,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  static double _niceInterval(double maxY) {
    if (maxY <= 0) return 1;
    final raw = maxY / 5;
    final pow10 = math.pow(10, (math.log(raw) / math.ln10).floor()).toDouble();
    final candidates = [1, 2, 5].map((m) => m * pow10).toList();
    return candidates.reduce(
      (a, b) => (raw - a).abs() < (raw - b).abs() ? a : b,
    );
  }

  static String _shortNumber(double v) {
    if (v >= 1e9) return '${(v / 1e9).toStringAsFixed(1)}B';
    if (v >= 1e6) return '${(v / 1e6).toStringAsFixed(1)}M';
    if (v >= 1e3) return '${(v / 1e3).toStringAsFixed(1)}k';
    return v.toStringAsFixed(0);
  }
}
