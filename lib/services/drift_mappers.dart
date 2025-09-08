import 'package:drift/drift.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/services/app_db.dart';

extension ExpenseRowMapper on ExpenseRow {
  Expense toDomain() => Expense(
    id: id,
    title: title,
    amount: amountMinor / 100,
    date: date,
    category: ExpenseCategory.values.byName(category),
  );
}

extension ExpenseDomainMapper on Expense {
  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      title: Value(title),
      amountMinor: Value((amount * 100).toInt()),
      date: Value(date),
      category: Value(category.name),
    );
  }
}