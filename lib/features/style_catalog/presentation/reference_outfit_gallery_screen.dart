import 'package:flutter/material.dart';
import 'package:smartclothes/core/constants/app_constants.dart';
import 'package:smartclothes/features/onboarding/models/user_preferences.dart';
import 'package:smartclothes/features/style_catalog/models/reference_outfit.dart';
import 'package:smartclothes/features/style_catalog/presentation/reference_outfit_artwork.dart';

/// A browseable 40-look catalog. Saving requires at least five choices.
class ReferenceOutfitGalleryScreen extends StatefulWidget {
  const ReferenceOutfitGalleryScreen({
    super.key,
    required this.onSave,
    this.initialSelection = const <String>{},
  });

  final Set<String> initialSelection;
  final Future<void> Function(Set<String> selectedIds) onSave;

  @override
  State<ReferenceOutfitGalleryScreen> createState() =>
      _ReferenceOutfitGalleryScreenState();
}

class _ReferenceOutfitGalleryScreenState extends State<ReferenceOutfitGalleryScreen> {
  static const int minimumSelection = 5;
  final Set<String> _selected = <String>{};
  ClothingStyle? _styleFilter;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final validIds = referenceOutfits.map((outfit) => outfit.id).toSet();
    _selected.addAll(widget.initialSelection.intersection(validIds));
  }

  Future<void> _save() async {
    if (_saving || _selected.length < minimumSelection) return;
    setState(() => _saving = true);
    try {
      await widget.onSave(Set<String>.of(_selected));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kombinler kaydedilemedi. Tekrar dene.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final outfits = referenceOutfits
        .where((outfit) => _styleFilter == null || outfit.style == _styleFilter)
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Stil Kataloğu')),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hangi kombinler seni yansıtıyor?',
                    style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.sm),
                  const Text('40 özgün çizimli kombin arasından en az 5 tanesini seç. Beğenilerin yalnızca bu cihazda saklanır.'),
                  const SizedBox(height: AppSpacing.md),
                  Text('${_selected.length} / 5 seçildi',
                    style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.xs),
                  LinearProgressIndicator(value: (_selected.length / minimumSelection).clamp(0.0, 1.0).toDouble()),
                ],
              ),
            ),
            SizedBox(
              height: 47,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: const Text('Tümü'),
                      selected: _styleFilter == null,
                      onSelected: (_) => setState(() => _styleFilter = null),
                    ),
                  ),
                  ...ClothingStyle.values.map((style) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(style.label),
                      selected: _styleFilter == style,
                      onSelected: (_) => setState(() => _styleFilter = style),
                    ),
                  )),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => GridView.builder(
                  key: const ValueKey('reference-outfit-grid'),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: outfits.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: constraints.maxWidth >= 800 ? 4 : constraints.maxWidth >= 540 ? 3 : 2,
                    childAspectRatio: constraints.maxWidth >= 540 ? 0.65 : 0.49,
                    crossAxisSpacing: AppSpacing.mdSm,
                    mainAxisSpacing: AppSpacing.mdSm,
                  ),
                  itemBuilder: (context, index) {
                    final outfit = outfits[index];
                    final chosen = _selected.contains(outfit.id);
                    return Card(
                      margin: EdgeInsets.zero,
                      color: chosen ? colors.primaryContainer : colors.surface,
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        key: ValueKey('reference-${outfit.id}'),
                        onTap: _saving ? null : () => setState(() {
                          if (! _selected.add(outfit.id)) _selected.remove(outfit.id);
                        }),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ReferenceOutfitArtwork(outfit: outfit),
                              const SizedBox(height: AppSpacing.sm),
                              Text(outfit.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleSmall),
                              Text('${outfit.style.label} · ${outfit.occasion} · ${outfit.season}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 4),
                              Expanded(
                                child: Text('${outfit.palette} · ${outfit.fit}\n${outfit.itemSummary}',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall),
                              ),
                              Row(
                                children: [
                                  Icon(chosen ? Icons.favorite : Icons.favorite_border,
                                    color: chosen ? colors.primary : colors.onSurfaceVariant,
                                    size: 20),
                                  const SizedBox(width: 4),
                                  Expanded(child: Text(chosen ? 'Beğendim' : 'Seç',
                                    style: Theme.of(context).textTheme.labelSmall)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
              child: FilledButton(
                key: const ValueKey('save-outfit-favorites'),
                onPressed: _selected.length >= minimumSelection && !_saving ? _save : null,
                child: _saving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(_selected.length >= minimumSelection
                        ? 'Seçimlerimi Kaydet (${_selected.length})'
                        : 'En az 5 kombin seç'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
