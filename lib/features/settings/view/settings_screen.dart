import 'package:expense_tracker/features/settings/viewmodel/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            subtitle: Text(vm.themeLabel()),
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
              '${vm.currencyCode}  ${vm.kCurrencies[vm.currencyCode] ?? ''}',
            ),
            trailing: DropdownButton<String>(
              value: vm.currencyCode,
              onChanged: (c) async =>
                  await vm.setCurrency(c ?? vm.currencyCode),
              items: vm.kCurrencies.keys
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text('$c  ${vm.kCurrencies[c]}'),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
