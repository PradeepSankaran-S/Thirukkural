import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/thirukkural_provider.dart';
import '../../core/widgets/common_appbar.dart';
import '../../core/widgets/common_card.dart';
import '../../data/models/paal_model.dart';
import '../../data/models/iyal_model.dart';
import '../../routes/app_routes.dart';

class IyalsPage extends StatelessWidget {
  const IyalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final paal = ModalRoute.of(context)!.settings.arguments as PaalModel;
    final provider = context.watch<ThirukkuralProvider>();
    final theme = Theme.of(context);

    final iyals = provider.repository.getIyalsForPaal(paal.id ?? 1);

    // Dynamic headers/accents
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
        title: paal.nameTamil ?? 'இயல்கள்',
        showThemeToggle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        physics: const BouncingScrollPhysics(),
        itemCount: iyals.length,
        itemBuilder: (context, index) {
          final IyalModel iyal = iyals[index];
          return CommonCard(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.athigarams,
                arguments: {
                  'iyal': iyal,
                  'paal': paal,
                },
              );
            },
            child: Row(
              children: [
                // Iyal Index Circle
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.08),
                    shape: BoxShape.circle,
                    border: Border.all(color: accentColor.withOpacity(0.2), width: 1),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Title and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        iyal.name ?? '',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontFamily: 'serif',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        iyal.translation ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        iyal.transliteration ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.secondary,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
