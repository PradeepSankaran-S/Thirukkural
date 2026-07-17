import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/thirukkural_provider.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'routes/app_pages.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThirukkuralProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThirukkuralProvider>();

    return MaterialApp(
      title: 'Thirukkural',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppRoutes.splash,
      routes: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
