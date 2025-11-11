import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  final bool isCompact;

  const ThemeToggleButton({
    Key? key,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        if (isCompact) {
          return IconButton(
            onPressed: () => themeProvider.toggleTheme(),
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            tooltip: themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.light_mode,
                  color: !themeProvider.isDarkMode
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (_) => themeProvider.toggleTheme(),
                  activeColor: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.dark_mode,
                  color: themeProvider.isDarkMode
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
