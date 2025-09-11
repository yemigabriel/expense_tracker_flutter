import 'package:expense_tracker/models/expense.dart';

class CategoryTotal {
  final String label;
  final double total;
  CategoryTotal(this.label, this.total);
}

List<CategoryTotal> buildCategoryTotals(List<Expense> items) {
  final map = <String, double>{};
  for (final e in items) {
    final key = e.category.name; // or a nicer label if you have one
    map[key] = (map[key] ?? 0) + e.amount;
  }
  return map.entries.map((e) => CategoryTotal(e.key, e.value)).toList();
}

List<CategoryTotal> topCategories(List<CategoryTotal> data) {
  final sorted = [...data]..sort((a, b) => b.total.compareTo(a.total));
  if (sorted.length <= 5) return sorted;
  final head = sorted.take(5).toList();
  final other = sorted.skip(5).fold<double>(0, (s, e) => s + e.total);
  return [...head, CategoryTotal('Other', other)];
}