import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/notification/local_notifications_provider.dart';
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
    final String currentTime = spProv.notificationTimeString;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                              DropdownMenuItem(
                                value: true,
                                child: Text('Dark'),
                              ),
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

              InkWell(
                onTap: currentNotifEnabled ? () => _selectTime(context) : null,
                child: Opacity(
                  opacity: currentNotifEnabled ? 1.0 : 0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 30,
                          color: Theme.of(context).colorScheme.inverseSurface,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Waktu notifikasi',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Text(
                          currentTime,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                ),
              ),

              InkWell(
                onTap: currentNotifEnabled ? _showPreviewNotification : null,
                child: Opacity(
                  opacity: currentNotifEnabled ? 1.0 : 0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.notification_important_outlined,
                          size: 30,
                          color: Theme.of(context).colorScheme.inverseSurface,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Tes Notifikasi',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final preferencesProvider = context.read<SharedPreferencesProvider>();
    if (!preferencesProvider.isNotificationEnabled) return;

    final notificationProvider = context.read<LocalNotificationProvider>();
    final currentHour = preferencesProvider.notificationHour;
    final currentMinute = preferencesProvider.notificationMinute;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: currentHour, minute: currentMinute),
    );

    if (selectedTime != null && mounted) {
      await preferencesProvider.setNotificationTime(
        selectedTime.hour,
        selectedTime.minute,
      );

      if (!mounted) return;

      await notificationProvider.updateNotificationTime(
        selectedTime.hour,
        selectedTime.minute,
      );

      _showSnack('Waktu notifikasi berhasil diubah!');
    }
  }

  Future<void> _toggleNotification(bool enabled) async {
    if (enabled) {
      await context.read<LocalNotificationProvider>().requestPermission();
    }

    if (!mounted) return;
    await context.read<LocalNotificationProvider>().setEnabled(enabled);

    if (!mounted) return;
    await context.read<SharedPreferencesProvider>().setNotification(enabled);

    _showSnack(enabled ? 'Notifikasi diaktifkan' : 'Notifikasi dimatikan');
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  Future<void> _showPreviewNotification() async {
    final preferencesProvider = context.read<SharedPreferencesProvider>();
    if (!preferencesProvider.isNotificationEnabled) return;

    await context.read<LocalNotificationProvider>().requestPermission();

    if (!mounted) return;
    await context.read<LocalNotificationProvider>().showPreviewNotification();

    _showSnack('Preview notifikasi dikirim');
  }
}
