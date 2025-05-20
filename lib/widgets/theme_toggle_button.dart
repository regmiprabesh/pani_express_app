import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pani_express/blocs/theme/theme_bloc.dart';
import 'package:pani_express/blocs/theme/theme_event.dart';
import 'package:pani_express/blocs/theme/theme_state.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                    _getThemeTitle(context, state.themeMode),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16.0),
                  _buildThemeOption(
                    context,
                    title: localizations.lightMode,
                    icon: Icons.wb_sunny_outlined,
                    themeMode: ThemeMode.light,
                    isSelected: state.themeMode == ThemeMode.light,
                  ),
                  const SizedBox(height: 8.0),
                  _buildThemeOption(
                    context,
                    title: localizations.darkMode,
                    icon: Icons.nightlight_round,
                    themeMode: ThemeMode.dark,
                    isSelected: state.themeMode == ThemeMode.dark,
                  ),
                  const SizedBox(height: 8.0),
                  _buildThemeOption(
                    context,
                    title: localizations.systemMode,
                    icon: Icons.phone_android,
                    themeMode: ThemeMode.system,
                    isSelected: state.themeMode == ThemeMode.system,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getThemeTitle(BuildContext context, ThemeMode themeMode) {
    final localizations = AppLocalizations.of(context)!;

    switch (themeMode) {
      case ThemeMode.light:
        return localizations.lightMode;
      case ThemeMode.dark:
        return localizations.darkMode;
      case ThemeMode.system:
        return localizations.systemMode;
    }
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required ThemeMode themeMode,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        // Change app theme
        context.read<ThemeBloc>().add(ThemeChanged(themeMode));
      },
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Theme.of(context).colorScheme.primary : null,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color:
                      isSelected ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
