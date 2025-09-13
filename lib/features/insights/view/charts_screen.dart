import 'package:expense_tracker/features/expenses/viewmodel/expenses_view_model.dart';
import 'package:expense_tracker/features/insights/view/bar_chart.dart';
import 'package:expense_tracker/features/insights/view/donut_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenses = context.watch<ExpensesViewModel>().expenses;
    return Wrap(
      runSpacing: 20,
      children: [
        Text(
          'Top 5 Categories (Last 30 days)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Card.outlined(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: DonutCategoryChart(expenses: expenses),
          ),
        ),
        Text(
          'Monthly Expenses',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: MonthlyTotalsBarChart(expenses: expenses),
          ),
        ),
      ],
    );
  }
}
