import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/thirukkural_provider.dart';
import '../../core/widgets/common_appbar.dart';
import '../../core/widgets/common_card.dart';
import '../../data/models/paal_model.dart';
import '../../data/models/iyal_model.dart';
import '../../data/models/athigaram_model.dart';
import '../../routes/app_routes.dart';

class AthigaramsPage extends StatefulWidget {
  const AthigaramsPage({super.key});

  @override
  State<AthigaramsPage> createState() => _AthigaramsPageState();
}

class _AthigaramsPageState extends State<AthigaramsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _filterQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final iyal = args['iyal'] as IyalModel;
    final paal = args['paal'] as PaalModel;

    final provider = context.watch<ThirukkuralProvider>();
    final theme = Theme.of(context);

    final allAthigarams = provider.repository.getAthigaramsForIyal(iyal.iyalNo ?? 1);
    
    // Filter athigarams based on user typing
    final filteredAthigarams = allAthigarams.where((a) {
      if (_filterQuery.isEmpty) return true;
      final query = _filterQuery.toLowerCase();
      final name = a.name?.toLowerCase() ?? '';
      final translation = a.translation?.toLowerCase() ?? '';
      final translit = a.transliteration?.toLowerCase() ?? '';
      final chapterNo = a.athigaramNo?.toString() ?? '';
      
      return name.contains(query) ||
          translation.contains(query) ||
          translit.contains(query) ||
          chapterNo == query;
    }).toList();

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
        title: iyal.name ?? 'அதிகாரங்கள்',
        showThemeToggle: false,
      ),
      body: Column(
        children: [
          // Filter Search Bar inside the page
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _filterQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Filter chapters within ${iyal.name}...',
                prefixIcon: Icon(Icons.filter_list_rounded, color: accentColor),
                suffixIcon: _filterQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _filterQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: theme.brightness == Brightness.dark
                    ? const Color(0xFF201E1D)
                    : Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.08)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: accentColor.withOpacity(0.5), width: 1.5),
                ),
              ),
            ),
          ),
          // Chapters List
          Expanded(
            child: filteredAthigarams.isEmpty
                ? Center(
                    child: Text(
                      'No chapters matched the filter.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredAthigarams.length,
                    itemBuilder: (context, index) {
                      final AthigaramModel athigaram = filteredAthigarams[index];
                      final chapterNo = int.tryParse(athigaram.athigaramNo.toString()) ?? 0;

                      return CommonCard(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.kurals,
                            arguments: {
                              'athigaram': athigaram,
                              'iyal': iyal,
                              'paal': paal,
                            },
                          );
                        },
                        child: Row(
                          children: [
                            // Chapter Number Box
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: accentColor.withOpacity(0.15), width: 1),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Ch',
                                    style: TextStyle(
                                      color: accentColor.withOpacity(0.6),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '$chapterNo',
                                    style: TextStyle(
                                      color: accentColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    athigaram.name ?? '',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontFamily: 'serif',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    athigaram.translation ?? '',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    athigaram.transliteration ?? '',
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
          ),
        ],
      ),
    );
  }
}
