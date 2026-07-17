import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/thirukkural_provider.dart';
import '../../core/widgets/common_appbar.dart';
import '../../core/widgets/common_card.dart';
import '../../routes/app_routes.dart';
import '../../data/models/paal_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThirukkuralProvider>();
    final theme = Theme.of(context);
    final isDark = provider.isDarkMode;

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final paals = provider.repository.getPaals();
    final kuralOfDay = provider.kuralOfTheDay;

    return Scaffold(
      appBar: const CommonAppBar(
        title: 'திருக்குறள்',
        showThemeToggle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Text(
              'வணக்கம்',
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 26,
                fontFamily: 'serif',
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Explore the timeless wisdom of Sage Thiruvalluvar',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),

            // Search Bar Shortcut
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.search),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF201E1D) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: theme.colorScheme.primary.withOpacity(0.6)),
                    const SizedBox(width: 12),
                    Text(
                      'Search by Kural number, word, or meaning...',
                      style: TextStyle(
                        color: theme.colorScheme.onBackground.withOpacity(0.4),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions (Favorites & Stats)
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    title: 'Favorites',
                    subtitle: '${provider.favorites.length} Kurals saved',
                    icon: Icons.favorite_rounded,
                    color: const Color(0xFFE57373),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.favorites),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    title: 'Structure',
                    subtitle: '133 Chapters',
                    icon: Icons.grid_view_rounded,
                    color: theme.colorScheme.secondary,
                    onTap: () {
                      // Just show a nice snackbar detailing the structure
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Thirukkural contains 3 Books (Paal), 13 Sections (Iyal), 133 Chapters (Athigaram) & 1,330 Couplets (Kural).'),
                          duration: Duration(seconds: 4),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Kural of the Day
            if (kuralOfDay != null) ...[
              Text(
                'இன்றைய குறள் (Kural of the Day)',
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 8),
              CommonCard(
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.kuralDetail,
                  arguments: kuralOfDay.number,
                ),
                borderSide: BorderSide(color: theme.colorScheme.secondary.withOpacity(0.3), width: 1.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Kural #${kuralOfDay.number}',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded, size: 14, color: theme.colorScheme.secondary),
                      ],
                    ),
                    const SizedBox(height: 12),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        kuralOfDay.line1 ?? '',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'serif',
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        kuralOfDay.line2 ?? '',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'serif',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Divider(color: theme.colorScheme.primary.withOpacity(0.06), height: 1),
                    const SizedBox(height: 10),
                    Text(
                      kuralOfDay.translation ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Paals Section (Aram, Porul, Inbam)
            Text(
              'அதிகாரப் பிரிவுகள் (Books of Thirukkural)',
              style: theme.textTheme.titleLarge?.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: paals.length,
              itemBuilder: (context, index) {
                final paal = paals[index];
                return _buildPaalCard(context, paal);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF201E1D) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.primary.withOpacity(0.06), width: 1),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.secondary.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaalCard(BuildContext context, PaalModel paal) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Rich styling depending on the Paal
    Color paalColor;
    String description;
    String iconChar;

    switch (paal.id) {
      case 1:
        paalColor = const Color(0xFF388E3C); // Green for Virtue
        description = 'அறத்துப்பால் - Virtuous and moral guidelines for individual life.';
        iconChar = 'அ';
        break;
      case 2:
        paalColor = const Color(0xFFE65100); // Orange/Amber for Wealth
        description = 'பொருட்பால் - Wisdom on statecraft, wealth, citizenship, and society.';
        iconChar = 'பொ';
        break;
      case 3:
        paalColor = const Color(0xFFD81B60); // Pink/Rose for Love
        description = 'இன்பத்துப்பால் - Beautiful couplets on pre-marital and post-marital love.';
        iconChar = 'இ';
        break;
      default:
        paalColor = theme.colorScheme.primary;
        description = '';
        iconChar = '';
    }

    return CommonCard(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.iyals,
          arguments: paal,
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Decorative Character Circle
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [paalColor.withOpacity(0.85), paalColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: paalColor.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                iconChar,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'serif',
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      paal.nameTamil ?? '',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontFamily: 'serif',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: paalColor,
                      ),
                    ),
                    Text(
                      paal.nameEnglish ?? '',
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? theme.textTheme.bodyMedium?.color?.withOpacity(0.7) : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.secondary.withOpacity(0.8),
          ),
        ],
      ),
    );
  }
}
