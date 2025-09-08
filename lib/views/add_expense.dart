import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/view_model/expenses_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  late final TextEditingController _amount;
  late final TextEditingController _description;
  String? _selectedCategory;

  @override
  void initState() {
    _amount = TextEditingController();
    _description = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _amount.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ExpensesViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          spacing: 25.0,
          children: [
            TextField(
              controller: _amount,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            TextField(
              controller: _description,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            DropdownButtonFormField(
              items: [
                for (var category in ExpenseCategory.values)
                  DropdownMenuItem(value: category, child: Text(category.name)),
              ],
              onChanged: (value) {
                _selectedCategory = value?.name;
              },
              decoration: InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  final amount = double.tryParse(_amount.text) ?? 0;
                  final description = _description.text;
                  final expense = Expense(
                    title: description,
                    amount: amount,
                    category: _selectedCategory != null
                        ? ExpenseCategory.values.firstWhere(
                            (e) => e.name == _selectedCategory,
                          )
                        : ExpenseCategory.others,
                    date: DateTime.now(),
                  );
                  vm.addExpense(expense);
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: Text("Add Expense"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
