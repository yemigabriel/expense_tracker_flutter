import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/services/app_db.dart';
import 'package:expense_tracker/view_model/expenses_view_model.dart';
import 'package:expense_tracker/views/main_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  final appDb = AppDb();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ExpensesViewModel(appDb),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        fontFamily: "Roboto",
      ),
      home: const MainTabView(),
    );
  }
}

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExpensesViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Provider Smoke Test')),
      body: Center(
        child: Text(
          'Count: ${vm.expenses.length}',
          style: const TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<ExpensesViewModel>().addExpense(
          Expense(
            title: "title",
            amount: 90,
            date: DateTime.now(),
            category: ExpenseCategory.food,
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
