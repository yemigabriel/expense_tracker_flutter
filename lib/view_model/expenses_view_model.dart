import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/services/app_db.dart';
import 'package:flutter/foundation.dart';

class ExpensesViewModel extends ChangeNotifier {
  final AppDb _appDb;
  final List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  ExpensesViewModel(this._appDb) {
    _appDb.watchAllExpenses().listen((items) {
      _expenses
        ..clear()
        ..addAll(items);
      notifyListeners();
    });
  }

  double get totalAmount {
    return _expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  void sortExpensesByDate() {
    _expenses.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  void addExpense(Expense expense) {
    _appDb.upsertExpense(expense);
  }

  void removeExpense(Expense expense) {
    _appDb.deleteById(expense.id);
  }

  List<Expense> getExpensesByCategory(String category) {
    return _expenses
        .where((expense) => expense.category.name == category)
        .toList();
  }
}
