import 'package:expense_tracker/features/insights/viewmodel/insights_view_model.dart';
import 'package:expense_tracker/features/insights/view/charts_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InsightsViewModel>();

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
                  card('Monthly Total', vm.monthTotal().toStringAsFixed(2)),
                  card(
                    'Biggest Category',
                    vm.biggestCategoryThisMonth().category,
                    sub:
                        '${vm.biggestCategoryThisMonth().percentage.toStringAsFixed(0)}% share',
                  ),
                  card(
                    'Most Expensive Day',
                    vm.mostExpensiveDayThisMonth().total.toStringAsFixed(2),
                    sub: vm
                        .mostExpensiveDayThisMonth()
                        .day
                        .toLocal()
                        .toString()
                        .split(' ')
                        .first,
                  ),
                  card('No-Spend Days', '${vm.noSpendDaysThisMonth()}'),
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
