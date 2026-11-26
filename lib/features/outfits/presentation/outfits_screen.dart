import 'package:flutter/material.dart';
import 'package:smartclothes/core/constants/app_constants.dart';
import 'package:smartclothes/features/auth/services/auth_service.dart';
import 'package:smartclothes/features/outfits/models/suggested_outfit.dart';
import 'package:smartclothes/features/outfits/services/outfit_recommendation_service.dart';
import 'package:smartclothes/features/wardrobe/models/clothing_item.dart';
import 'package:smartclothes/features/wardrobe/models/clothing_labels.dart';
import 'package:smartclothes/features/wardrobe/repositories/wardrobe_repository.dart';
import 'package:smartclothes/features/wardrobe/repositories/wardrobe_repository_factory.dart';

/// Outfit recommendations built from the current user's owned clean garments.
/// Returns to the latest wardrobe state whenever the Kombinler tab reopens.
class OutfitsScreen extends StatefulWidget {
  const OutfitsScreen({
    super.key,
    this.isActive = true,
    this.ownerId,
    this.repository,
  });

  final bool isActive;
  final String? ownerId;
  final WardrobeRepository? repository;

  @override
  State<OutfitsScreen> createState() => _OutfitsScreenState();
}

class _OutfitsScreenState extends State<OutfitsScreen> {
  static const _engine = OutfitRecommendationService();
  List<ClothingItem> _wardrobe = <ClothingItem>[];
  ClothingSeason? _season;
  ClothingOccasion? _occasion;
  bool _loading = false;
  bool _hasAccount = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.isActive) _reload();
  }

  @override
  void didUpdateWidget(covariant OutfitsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((!oldWidget.isActive && widget.isActive) ||
        oldWidget.ownerId != widget.ownerId ||
        oldWidget.repository != widget.repository) {
      if (widget.isActive) _reload();
    }
  }

  Future<void> _reload() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final auth = AuthService.instance;
      final owner = widget.ownerId ??
          (auth.isDemoMode.value ? 'demo' : auth.currentUser?.uid);
      final repository = widget.repository ??
          (owner == null
              ? null
              : WardrobeRepositoryFactory.forCurrentSession());
      final garments = owner == null || repository == null
          ? <ClothingItem>[]
          : await repository.listItems(owner);
      if (!mounted) return;
      setState(() {
        // Discard any incorrectly attributed records from legacy storage.
        _wardrobe = garments.where((item) => item.ownerId == owner).toList();
        _hasAccount = owner != null;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Kombinler hazırlanamadı. Yeniden dene.';
      });
    }
  }

  String _missingPieces() {
    final clean = _wardrobe
        .where((item) => item.laundryStatus == LaundryStatus.clean)
        .where((item) =>
            _season == null || item.seasons.isEmpty ||
            item.seasons.contains(_season))
        .where((item) =>
            _occasion == null || item.occasions.isEmpty ||
            item.occasions.contains(_occasion))
        .toList();
    final categories = clean.map((item) => item.category).toSet();
    if (!categories.contains(ClothingCategory.shoes)) {
      return 'En az bir temiz ayakkabı ekle.';
    }
    if (!categories.contains(ClothingCategory.dresses) &&
        !(categories.contains(ClothingCategory.tops) &&
            categories.contains(ClothingCategory.bottoms))) {
      return 'Temiz üst + alt veya elbise ekle.';
    }
    return 'Seçilen filtrelere uygun temiz parçalar bulunamadı.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final owner = widget.ownerId ??
        (AuthService.instance.isDemoMode.value
            ? 'demo'
            : AuthService.instance.currentUser?.uid);
    final results = owner == null
        ? <SuggestedOutfit>[]
        : _engine.recommend(
            ownerId: owner,
            wardrobe: _wardrobe,
            season: _season,
            occasion: _occasion,
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kombinlerim'),
        centerTitle: false,
        actions: [
          IconButton(
            key: const ValueKey('reload-outfit-suggestions'),
            tooltip: 'Kombinleri Yenile',
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _reload,
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: TextButton.icon(
                      icon: const Icon(Icons.refresh),
                      onPressed: _reload,
                      label: Text(_error!),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    children: [
                      Text('Gerçek kıyafetlerden öneri',
                          style: theme.textTheme.titleLarge),
                      const SizedBox(height: AppSpacing.xs),
                      const Text(
                        'Öneriler yalnızca dolabındaki temiz parçalarla hazırlanır. '
                        'Yapay zekâ ve hava durumu bağlantısı henüz kullanılmaz.',
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (_wardrobe.isNotEmpty) ...[
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: [
                            DropdownButton<ClothingSeason?>(
                              key: const ValueKey('outfits-season-filter'),
                              value: _season,
                              hint: const Text('Tüm mevsimler'),
                              items: [
                                const DropdownMenuItem<ClothingSeason?>(
                                  value: null,
                                  child: Text('Tüm mevsimler'),
                                ),
                                ...ClothingSeason.values.map((value) =>
                                    DropdownMenuItem<ClothingSeason?>(
                                      value: value,
                                      child: Text(value.label),
                                    )),
                              ],
                              onChanged: (value) =>
                                  setState(() => _season = value),
                            ),
                            DropdownButton<ClothingOccasion?>(
                              key: const ValueKey('outfits-occasion-filter'),
                              value: _occasion,
                              hint: const Text('Tüm kullanım alanları'),
                              items: [
                                const DropdownMenuItem<ClothingOccasion?>(
                                  value: null,
                                  child: Text('Tüm kullanım alanları'),
                                ),
                                ...ClothingOccasion.values.map((value) =>
                                    DropdownMenuItem<ClothingOccasion?>(
                                      value: value,
                                      child: Text(value.label),
                                    )),
                              ],
                              onChanged: (value) =>
                                  setState(() => _occasion = value),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      if (results.isEmpty) ...[
                        const SizedBox(height: AppSpacing.xl),
                        Center(
                          child: Icon(
                            Icons.auto_awesome_outlined,
                            size: 60,
                            color: colors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Henüz oluşturulmuş bir kombin yok',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          !_hasAccount
                              ? 'Kombin oluşturmak için giriş yap veya demo modunu aç.'
                              : _wardrobe.isEmpty
                                  ? 'Önce Dolabım ekranına kıyafetlerini ekle.'
                                  : _missingPieces(),
                          textAlign: TextAlign.center,
                        ),
                      ] else ...[
                        Text(
                          '${results.length} kombin önerisi',
                          key: const ValueKey('outfit-suggestion-count'),
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ...results.asMap().entries.map((entry) {
                          final suggested = entry.value;
                          return Card(
                            key: ValueKey('suggestion-${entry.key}'),
                            margin: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kombin ${entry.key + 1}',
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  ...suggested.items.map((item) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: AppSpacing.xs,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.checkroom_outlined,
                                                color: colors.primary,
                                                size: 20),
                                            const SizedBox(width: AppSpacing.sm),
                                            Expanded(
                                              child: Text(
                                                '${item.name} · ${item.category.label} '
                                                '· ${item.color}',
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                  const SizedBox(height: AppSpacing.sm),
                                  Wrap(
                                    spacing: AppSpacing.sm,
                                    runSpacing: AppSpacing.xs,
                                    children: suggested.reasons.map((reason) =>
                                        Chip(label: Text(reason))).toList(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
      ),
    );
  }
}
