import 'package:flutter/material.dart';
import '../modules/splash/splash_page.dart';
import '../modules/home/home_page.dart';
import '../modules/iyal/iyals_page.dart';
import '../modules/athigaram/athigarams_page.dart';
import '../modules/kural/kurals_page.dart';
import '../modules/kural/kural_detail_page.dart';
import '../modules/search/search_page.dart';
import '../modules/favorites/favorites_page.dart';
import 'app_routes.dart';

class AppPages {
  static Map<String, WidgetBuilder> get routes => {
        AppRoutes.splash: (context) => const SplashPage(),
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.iyals: (context) => const IyalsPage(),
        AppRoutes.athigarams: (context) => const AthigaramsPage(),
        AppRoutes.kurals: (context) => const KuralsPage(),
        AppRoutes.kuralDetail: (context) => const KuralDetailPage(),
        AppRoutes.search: (context) => const SearchPage(),
        AppRoutes.favorites: (context) => const FavoritesPage(),
      };
}
