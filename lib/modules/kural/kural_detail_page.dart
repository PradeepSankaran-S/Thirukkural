import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/providers/thirukkural_provider.dart';
import '../../core/widgets/common_appbar.dart';
import '../../core/widgets/common_card.dart';
import '../../data/models/kural_model.dart';

class KuralDetailPage extends StatelessWidget {
  const KuralDetailPage({super.key});

  void _copyToClipboard(BuildContext context, Kural kural) {
    final text = 'குறள் ${kural.number}:\n'
        '${kural.line1}\n'
        '${kural.line2}\n\n'
        'Meaning / Explanation:\n'
        '${kural.explanation ?? kural.translation}\n\n'
        'Shared via Thirukkural App';
    
    Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kural #${kural.number} copied to clipboard!'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final kuralNo = ModalRoute.of(context)!.settings.arguments as int;
    final provider = context.watch<ThirukkuralProvider>();
    final theme = Theme.of(context);

    final kural = provider.repository.getKuralByNumber(kuralNo);
    if (kural == null || kural.line1 == null) {
      return Scaffold(
        appBar: const CommonAppBar(title: 'குறள் விவரம்', showThemeToggle: false),
        body: Center(
          child: Text('Kural #$kuralNo not found.', style: theme.textTheme.bodyLarge),
        ),
      );
    }

    final isFav = provider.isFavorite(kuralNo);
    
    // Determine book section / Paal based on kural number
    Color paalColor = theme.colorScheme.primary;
    String paalName = '';
    if (kuralNo >= 1 && kuralNo <= 380) {
      paalColor = const Color(0xFF388E3C);
      paalName = 'அறத்துப்பால் / Virtue';
    } else if (kuralNo >= 381 && kuralNo <= 1080) {
      paalColor = const Color(0xFFE65100);
      paalName = 'பொருட்பால் / Wealth';
    } else if (kuralNo >= 1081 && kuralNo <= 1330) {
      paalColor = const Color(0xFFD81B60);
      paalName = 'இன்பத்துப்பால் / Love';
    }

    return Scaffold(
      appBar: CommonAppBar(
        title: 'குறள் / Kural $kuralNo',
        showThemeToggle: false,
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFav ? Colors.redAccent : theme.appBarTheme.iconTheme?.color,
            ),
            tooltip: 'Bookmark',
            onPressed: () {
              provider.toggleFavorite(kuralNo);
            },
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded),
            tooltip: 'Copy Kural',
            onPressed: () => _copyToClipboard(context, kural),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Category Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: paalColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: paalColor.withOpacity(0.15), width: 1),
              ),
              child: Center(
                child: Text(
                  paalName,
                  style: TextStyle(
                    color: paalColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // The main Kural Card
            CommonCard(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              borderSide: BorderSide(color: paalColor.withOpacity(0.2), width: 1.5),
              child: Column(
                children: [
                  // Tamil Couplet
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Text(
                      kural.line1 ?? '',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 20,
                        fontFamily: 'serif',
                        height: 1.5,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Text(
                      kural.line2 ?? '',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 20,
                        fontFamily: 'serif',
                        height: 1.5,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(color: theme.colorScheme.primary.withOpacity(0.08)),
                  const SizedBox(height: 14),

                  // Transliteration
                  Text(
                    'Transliteration:',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${kural.transliteration1}\n${kural.transliteration2}',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Translation
                  Text(
                    'English Translation:',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    kural.translation ?? '',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Scholars' Explanations header
            Text(
              'விளக்கங்கள் (Explanations)',
              style: theme.textTheme.titleLarge?.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 8),

            // M. Varadarajan (MV)
            if (kural.mv != null)
              _buildExplanationCard(
                context,
                scholarName: 'மு. வரதராசன் (M. Varadarajan)',
                explanationText: kural.mv!,
                accentColor: paalColor,
              ),

            // Solomon Pappaiah (SP)
            if (kural.sp != null)
              _buildExplanationCard(
                context,
                scholarName: 'சாலமன் பாப்பையா (Solomon Pappaiah)',
                explanationText: kural.sp!,
                accentColor: paalColor,
              ),

            // M. Karunanidhi (MK)
            if (kural.mk != null)
              _buildExplanationCard(
                context,
                scholarName: 'மு. கருணாநிதி (M. Karunanidhi)',
                explanationText: kural.mk!,
                accentColor: paalColor,
              ),

            // English Explanation
            if (kural.explanation != null)
              _buildExplanationCard(
                context,
                scholarName: 'English Commentary',
                explanationText: kural.explanation!,
                accentColor: theme.colorScheme.secondary,
                isEnglish: true,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationCard(
    BuildContext context, {
    required String scholarName,
    required String explanationText,
    required Color accentColor,
    bool isEnglish = false,
  }) {
    final theme = Theme.of(context);
    
    return CommonCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                scholarName,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            explanationText,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 14,
              fontFamily: isEnglish ? null : 'serif',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
