import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/thirukkural_provider.dart';
import '../../core/widgets/common_appbar.dart';
import '../../core/widgets/common_card.dart';
import '../../data/models/kural_model.dart';
import '../../routes/app_routes.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _queryController = TextEditingController();
  List<Kural> _results = [];
  bool _hasSearched = false;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query, ThirukkuralProvider provider) {
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _hasSearched = false;
      });
      return;
    }

    final searchResults = provider.repository.searchKurals(query);
    setState(() {
      _results = searchResults;
      _hasSearched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThirukkuralProvider>();
    final theme = Theme.of(context);
    final isDark = provider.isDarkMode;

    return Scaffold(
      appBar: const CommonAppBar(
        title: 'தேடல் / Search',
        showThemeToggle: false,
      ),
      body: Column(
        children: [
          // Elegant Search Input Box
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _queryController,
              autofocus: true,
              onChanged: (val) => _onSearchChanged(val, provider),
              decoration: InputDecoration(
                hintText: 'Search by Kural number, word or meaning...',
                prefixIcon: Icon(Icons.search_rounded, color: theme.colorScheme.primary),
                suffixIcon: _queryController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _queryController.clear();
                          _onSearchChanged('', provider);
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? const Color(0xFF201E1D) : Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.08)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: theme.colorScheme.secondary, width: 1.5),
                ),
              ),
            ),
          ),
          
          // Results
          Expanded(
            child: !_hasSearched
                ? _buildSuggestionsView(theme)
                : _results.isEmpty
                    ? _buildNoResultsView(theme)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                        physics: const BouncingScrollPhysics(),
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          final kural = _results[index];
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
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Kural #${kural.number}',
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    kural.line1 ?? '',
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
                                    kural.line2 ?? '',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'serif',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  kural.translation ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                  ),
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

  Widget _buildSuggestionsView(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
      child: Column(
        children: [
          Icon(
            Icons.menu_book_rounded,
            size: 60,
            color: theme.colorScheme.secondary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Explore Thirukkural',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You can search 1,330 couplets instantly. Try searching for:',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildSearchChip('Kural "1"'),
              _buildSearchChip('அகரம்'),
              _buildSearchChip('God'),
              _buildSearchChip('Rain'),
              _buildSearchChip('Virtue'),
              _buildSearchChip('Love'),
              _buildSearchChip('Friendship'),
              _buildSearchChip('Chapter "10"'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchChip(String label) {
    final theme = Theme.of(context);
    return ActionChip(
      label: Text(label),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: theme.colorScheme.primary,
      ),
      backgroundColor: theme.colorScheme.primary.withOpacity(0.04),
      side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.1)),
      onPressed: () {
        // Strip quotes or custom text for simple query filling
        final query = label.replaceAll('Kural "', '').replaceAll('Chapter "', '').replaceAll('"', '');
        _queryController.text = query;
        _onSearchChanged(query, Provider.of<ThirukkuralProvider>(context, listen: false));
      },
    );
  }

  Widget _buildNoResultsView(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 55,
              color: theme.colorScheme.secondary.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'No Kurals Found',
              style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 6),
            Text(
              'We couldn\'t find any couplets matching your search query. Try another keyword or kural number.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
