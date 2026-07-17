import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/thirukkural_provider.dart';
import '../../core/widgets/common_appbar.dart';
import '../../core/widgets/common_card.dart';
import '../../data/models/paal_model.dart';
import '../../data/models/athigaram_model.dart';
import '../../routes/app_routes.dart';

class KuralsPage extends StatelessWidget {
  const KuralsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final athigaram = args['athigaram'] as AthigaramModel;
    final paal = args['paal'] as PaalModel;

    final provider = context.watch<ThirukkuralProvider>();
    final theme = Theme.of(context);

    final chapterNo = int.tryParse(athigaram.athigaramNo.toString()) ?? 0;
    final kurals = provider.repository.getKuralsForAthigaram(chapterNo);

    // Dynamic color depending on Paal
    Color accentColor;
    switch (paal.id) {
      case 1:
        accentColor = const Color(0xFF388E3C);
        break;
      case 2:
        accentColor = const Color(0xFFE65100);
        break;
      case 3:
        accentColor = const Color(0xFFD81B60);
        break;
      default:
        accentColor = theme.colorScheme.primary;
    }

    return Scaffold(
      appBar: CommonAppBar(
        title: athigaram.name ?? 'குறள்கள்',
        showThemeToggle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        physics: const BouncingScrollPhysics(),
        itemCount: kurals.length,
        itemBuilder: (context, index) {
          final kural = kurals[index];
          final isFav = provider.isFavorite(kural.number ?? 0);

          return CommonCard(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.kuralDetail,
                arguments: kural.number,
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Kural Number and Favorite Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'குறள் / Kural #${kural.number}',
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFav ? Colors.redAccent : theme.colorScheme.secondary,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        provider.toggleFavorite(kural.number ?? 0);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Couplets in Tamil
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    kural.line1 ?? '',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'serif',
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    kural.line2 ?? '',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'serif',
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Divider(color: theme.colorScheme.primary.withOpacity(0.06), height: 1),
                const SizedBox(height: 10),
                // English translation preview
                Text(
                  kural.translation ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
