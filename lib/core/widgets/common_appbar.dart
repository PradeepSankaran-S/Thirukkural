import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/thirukkural_provider.dart';
import '../../routes/app_routes.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showThemeToggle;
  final bool showHomeButton;

  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showThemeToggle = true,
    this.showHomeButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThirukkuralProvider>();

    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      centerTitle: true,
      elevation: 0,
      actions: [
        ...?actions,
        if (showThemeToggle)
          IconButton(
            icon: Icon(
              provider.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              size: 22,
            ),
            tooltip: 'Toggle Theme',
            onPressed: () {
              provider.toggleTheme();
            },
          ),
        if (showHomeButton)
          IconButton(
            icon: const Icon(Icons.home_outlined, size: 22),
            tooltip: 'Go Home',
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
