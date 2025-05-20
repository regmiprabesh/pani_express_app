import 'package:flutter/material.dart';
import 'package:pani_express/widgets/language_selector.dart';
import 'package:pani_express/widgets/theme_toggle_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                localizations.settings,
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),

            // Theme selector
            const ThemeToggleButton(),
            const SizedBox(height: 16),

            // Language selector
            const LanguageSelector(),
            const SizedBox(height: 16),

            // App info card
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pure Aqua',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8.0),
                      const Text('Version 1.0.0'),
                      const SizedBox(height: 16.0),
                      Center(
                        child: Image.asset(
                          'assets/images/app_logo.png',
                          height: 80,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.water_drop,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        '© 2025 Pure Aqua. All rights reserved.',
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Notification settings
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notifications',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16.0),
                      SwitchListTile(
                        title: const Text('Order Updates'),
                        subtitle: const Text(
                            'Notifications for order status changes'),
                        value: true,
                        onChanged: (value) {
                          // TODO: Implement notification settings
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                      const Divider(),
                      SwitchListTile(
                        title: const Text('Promotions'),
                        subtitle: const Text(
                            'Notifications for offers and discounts'),
                        value: false,
                        onChanged: (value) {
                          // TODO: Implement notification settings
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                      const Divider(),
                      SwitchListTile(
                        title: const Text('Delivery Reminders'),
                        subtitle:
                            const Text('Reminders for upcoming deliveries'),
                        value: true,
                        onChanged: (value) {
                          // TODO: Implement notification settings
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
