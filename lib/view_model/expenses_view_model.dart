import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/services/app_db.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpensesViewModel extends ChangeNotifier {
  final AppDb _appDb;
  final List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;
  String _currencyCode;
  String get currencyCode => _currencyCode;
  NumberFormat get moneyFormat => NumberFormat.currency(name: _currencyCode);

  ExpensesViewModel(this._appDb, {required String currencyCode})
    : _currencyCode = currencyCode {
    _appDb.watchAllExpenses().listen((items) {
      _expenses
        ..clear()
        ..addAll(items);
      notifyListeners();
    });
  }

void setCurrency(String code) {
    if (_currencyCode == code) return;
    _currencyCode = code;
    notifyListeners(); // UI can reformat amounts
  }

  // Future<void> loadCurrency() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   _currencyCode = prefs.getString('currency_code') ?? 'NGN';
  //   notifyListeners();
  // }

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
