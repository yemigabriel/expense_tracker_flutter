import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/services/app_db.dart';
import 'package:expense_tracker/features/expenses/viewmodel/expenses_view_model.dart';
import 'package:expense_tracker/features/insights/viewmodel/insights_view_model.dart';
import 'package:expense_tracker/features/settings/viewmodel/settings_view_model.dart';
import 'package:expense_tracker/main_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDb>(create: (_) => AppDb(), dispose: (_, db) => db.close()),
        ChangeNotifierProvider<SettingsViewModel>(
          create: (context) => SettingsViewModel(prefs)..init(),
        ),
        ChangeNotifierProxyProvider<SettingsViewModel, ExpensesViewModel>(
          create: (context) => ExpensesViewModel(
            context.read<AppDb>(),
            currencyCode: context.read<SettingsViewModel>().currencyCode,
          ),
          update: (context, settingsVm, expensesVm) {
            expensesVm ??= ExpensesViewModel(
              context.read<AppDb>(),
              currencyCode:
                  settingsVm.kCurrencies[settingsVm.currencyCode] ?? 'NGN',
            );
            expensesVm.setCurrency(
              settingsVm.kCurrencies[settingsVm.currencyCode] ?? 'NGN',
            );
            return expensesVm;
          },
        ),
        ChangeNotifierProxyProvider2<
          ExpensesViewModel,
          SettingsViewModel,
          InsightsViewModel
        >(
          create: (_) => InsightsViewModel(),
          update: (context, expensesVm, settingsVm, insightsVm) {
            insightsVm ??= InsightsViewModel();
            insightsVm.update(
              expenses: expensesVm.expenses,
              currencyCode:
                  settingsVm.kCurrencies[settingsVm.currencyCode] ?? 'NGN',
            );
            return insightsVm;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final settingsVm = context.watch<SettingsViewModel>();
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      themeMode: settingsVm.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.light,
        ),
        fontFamily: "Ubuntu",
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.dark,
        ),
        fontFamily: "Roboto",
      ),
      home: const MainTabView(),
    );
  }
}
