import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/services/app_db.dart';
import 'package:expense_tracker/view_model/expenses_view_model.dart';
import 'package:expense_tracker/view_model/settings_view_model.dart';
import 'package:expense_tracker/views/main_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   final appDb = AppDb();
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => ExpensesViewModel(appDb)),
//         ChangeNotifierProvider(create: (_) => SettingsViewModel()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }
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
          create: (ctx) => ExpensesViewModel(
            ctx.read<AppDb>(),
            currencyCode: ctx.read<SettingsViewModel>().currencyCode,
          ),
          update: (ctx, settings, vm) {
            vm ??= ExpensesViewModel(
              ctx.read<AppDb>(),
              currencyCode: settings.currencyCode,
            );
            vm.setCurrency(settings.currencyCode);
            return vm;
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
