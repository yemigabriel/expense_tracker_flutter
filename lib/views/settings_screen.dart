import 'package:expense_tracker/view_model/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const kCurrencies = <String, String>{
  'USD': '\$',
  'NGN': '₦',
  'EUR': '€',
  'GBP': '£',
  'EGP': 'E£',
  'JPY': '¥',
};

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.file_upload_outlined),
            title: const Text('Theme'),
            subtitle: Text(_themeLabel(vm.themeMode)),
            trailing: DropdownButton<ThemeMode>(
              value: vm.themeMode,
              onChanged: (m) => vm.setThemeMode(m ?? ThemeMode.system),
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System'),
                ),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
            ),
          ),

          ListTile(
            leading: const Icon(Icons.file_upload_outlined),
            title: const Text('Currency'),
            subtitle: Text(
              '${vm.currencyCode}  ${kCurrencies[vm.currencyCode] ?? ''}',
            ),
            trailing: DropdownButton<String>(
              value: vm.currencyCode,
              onChanged: (c) async =>
                  await vm.setCurrency(c ?? vm.currencyCode),
              items: kCurrencies.keys
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text('$c  ${kCurrencies[c]}'),
                    ),
                  )
                  .toList(),
            ),
          ),

          // ListTile(
          //   leading: const Icon(Icons.delete_forever_outlined),
          //   title: const Text('Reset all data'),
          //   textColor: Theme.of(context).colorScheme.error,
          //   iconColor: Theme.of(context).colorScheme.error,
          //   onTap: () async {
          //     final ok = await showDialog<bool>(
          //       context: context,
          //       builder: (ctx) => AlertDialog(
          //         title: const Text('Reset all data?'),
          //         content: const Text(
          //           'This will permanently delete your expenses and settings.',
          //         ),
          //         actions: [
          //           TextButton(
          //             onPressed: () => Navigator.pop(ctx, false),
          //             child: const Text('Cancel'),
          //           ),
          //           FilledButton(
          //             onPressed: () => Navigator.pop(ctx, true),
          //             child: const Text('Reset'),
          //           ),
          //         ],
          //       ),
          //     );
          //     if (ok == true) await vm.resetData();
          //   },
          // ),
        ],
      ),
    );
  }

  static String _themeLabel(ThemeMode m) {
    switch (m) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }
}
