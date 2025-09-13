import 'dart:math';

import 'package:expense_tracker/features/expenses/viewmodel/expenses_view_model.dart';
import 'package:expense_tracker/features/expenses/view/add_expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ExpensesViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showBottomSheet(context);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: viewModel.expenses.isEmpty
            ? EmptyView(showBottomSheet: showBottomSheet)
            : ExpenseListView(),
      ),
    );
  }

  void addExpense(BuildContext context) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddExpense();
      },
    );
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) {
        return SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Wrap(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text("Add expenses manually"),
                  onTap: () => addExpense(context),
                ),
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text("Scan receipt"),
                ),
                ListTile(
                  leading: Icon(Icons.corporate_fare),
                  title: Text("Connect to bank account"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ExpenseListView extends StatelessWidget {
  const ExpenseListView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ExpensesViewModel>();
    return ListView.separated(
      itemBuilder: (context, index) {
        final expense = viewModel.expenses[index];
        return Dismissible(
          key: ValueKey(expense.id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            viewModel.removeExpense(expense);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Expense removed")));
          },
          background: Container(
            color: Colors.redAccent,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Icon(Icons.delete),
          ),
          child: ListTile(
            title: Text(
              viewModel.moneyFormat.format(viewModel.expenses[index].amount),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            subtitle: Text(viewModel.expenses[index].title),
            trailing: Text(
              "${viewModel.expenses[index].category.name} \n${viewModel.expenses[index].date.toLocal().toIso8601String().split('T').first}",
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 0.5),
      itemCount: viewModel.expenses.length,
    );
  }
}

class EmptyView extends StatelessWidget {
  final Function(BuildContext) showBottomSheet;
  const EmptyView({super.key, required this.showBottomSheet});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20.0,
      children: [
        Center(
          child: Image.asset(
            'assets/images/empty.png',
            width: MediaQuery.of(context).size.width / 1.5,
            fit: BoxFit.fitWidth,
          ),
        ),
        Center(
          child: Text(
            "No expenses yet",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              showBottomSheet(context);
            },
            icon: Icon(Icons.add),
            label: Text("Add your first expense"),
            style: ElevatedButton.styleFrom(
              // textStyle: Theme.of(context).textTheme.labelLarge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
