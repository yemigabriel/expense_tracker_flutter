import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/services/drift_mappers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

part 'app_db.g.dart';

@DataClassName('ExpenseRow')
class Expenses extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get title => text()();
  IntColumn get amountMinor => integer()();
  DateTimeColumn get date => dateTime()();
  TextColumn get category => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Expenses])
class AppDb extends _$AppDb {
  AppDb() : super(_open());

  @override
  int get schemaVersion => 1;

  Future<void> upsertExpense(Expense e) =>
      into(expenses).insertOnConflictUpdate(e.toCompanion(false));

  Stream<List<Expense>> watchAllExpenses() =>
      (select(expenses)..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .watch()
          .map((rows) => rows.map((r) => r.toDomain()).toList());

  Future<int> deleteById(String id) =>
      (delete(expenses)..where((t) => t.id.equals(id))).go();
}

LazyDatabase _open() => LazyDatabase(() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, 'expenses.db'));
  return NativeDatabase.createInBackground(file);
});
