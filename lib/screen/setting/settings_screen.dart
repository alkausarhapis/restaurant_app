import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/prefs/shared_preferences_provider.dart';
import 'package:restaurant_app/provider/theme/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final spProv = context.watch<SharedPreferencesProvider>();
    final bool currentIsDark = spProv.isDarkMode;
    final bool currentNotifEnabled = spProv.isNotificationEnabled;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Pengaturan',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            const SizedBox(height: 16),

            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.format_paint,
                      size: 30,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tema',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(width: 64),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<bool>(
                          value: currentIsDark,
                          items: const [
                            DropdownMenuItem(
                              value: false,
                              child: Text('Light'),
                            ),
                            DropdownMenuItem(value: true, child: Text('Dark')),
                          ],
                          onChanged: (value) async {
                            if (value == null) return;

                            context.read<ThemeProvider>().setMode(
                              value ? ThemeMode.dark : ThemeMode.light,
                            );

                            await context
                                .read<SharedPreferencesProvider>()
                                .setDarkMode(value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            InkWell(
              onTap: () async {
                final next = !currentNotifEnabled;
                await _toggleNotification(next);
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_active,
                      size: 30,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Notifikasi',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),

                    Switch.adaptive(
                      value: currentNotifEnabled,
                      onChanged: (value) async {
                        await _toggleNotification(value);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleNotification(bool enabled) async {
    await context.read<SharedPreferencesProvider>().setNotification(enabled);

    _showNotifSnack(enabled);
  }

  void _showNotifSnack(bool enabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          enabled ? 'Notifikasi diaktifkan' : 'Notifikasi dimatikan',
        ),
        duration: const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
      ),
    );
  }
}
