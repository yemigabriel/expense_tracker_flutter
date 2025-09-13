import 'package:expense_tracker/models/donut_chart_data.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DonutCategoryChart extends StatelessWidget {
  final NumberFormat moneyFmt;
  final List<Expense> expenses;
  const DonutCategoryChart({
    super.key,
    required this.expenses,
    required this.moneyFmt,
  });

  @override
  Widget build(BuildContext context) {
    final data = topCategories(buildCategoryTotals(expenses));
    final total = data.fold<double>(0, (s, e) => s + e.total);

    if (total == 0) {
      return const Center(child: Text('No expenses yet'));
    }

    final colors = <Color>[
      Colors.blue.shade300,
      Colors.orange.shade300,
      Colors.green.shade300,
      Colors.purple.shade300,
      Colors.teal.shade300,
      Colors.pink.shade300,
    ];

    final sections = <PieChartSectionData>[
      for (var i = 0; i < data.length; i++)
        PieChartSectionData(
          color: colors[i % colors.length],
          value: data[i].total, // fl_chart uses raw values; it computes angle
          title: _percentLabel(data[i].total, total),
          titleStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          radius: 70,
          badgeWidget: null,
        ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 1.4,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 48,
              sectionsSpace: 2,
              startDegreeOffset: -90,
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // simple legend
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            for (var i = 0; i < data.length; i++)
              _LegendDot(
                color: colors[i % colors.length],
                label: '${data[i].label} — ${moneyFmt.format(data[i].total)}',
              ),
          ],
        ),
      ],
    );
  }

  String _percentLabel(double part, double whole) {
    final p = (part / whole) * 100;
    return p >= 10 ? '${p.toStringAsFixed(0)}%' : '${p.toStringAsFixed(1)}%';
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
