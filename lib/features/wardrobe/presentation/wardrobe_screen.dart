import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:smartclothes/core/constants/app_constants.dart';
import 'package:smartclothes/features/auth/services/auth_service.dart';
import 'package:smartclothes/features/wardrobe/models/clothing_item.dart';
import 'package:smartclothes/features/wardrobe/models/clothing_labels.dart';
import 'package:smartclothes/features/wardrobe/presentation/clothing_item_editor_screen.dart';
import 'package:smartclothes/features/wardrobe/repositories/wardrobe_repository.dart';
import 'package:smartclothes/features/wardrobe/repositories/wardrobe_repository_factory.dart';
import 'package:smartclothes/features/wardrobe/services/wardrobe_image_store.dart';

/// The user's wardrobe: view, filter, search, edit and delete owned garments.
class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({
    super.key,
    this.ownerId,
    this.repository,
    this.images,
    this.pickPhoto,
  });

  /// Optional injected dependencies make UI tests independent of Firebase.
  final String? ownerId;
  final WardrobeRepository? repository;
  final WardrobeImageStore? images;
  final Future<PickedWardrobePhoto?> Function()? pickPhoto;

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  List<ClothingItem> _items = [];
  String? _ownerId;
  WardrobeRepository? _repository;
  WardrobeImageStore? _images;
  ClothingCategory? _selectedCategory;
  LaundryStatus? _laundryFilter;
  bool _onlyFavorites = false;
  bool _loading = true;
  bool _busy = false;
  String? _error;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void didUpdateWidget(covariant WardrobeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ownerId != widget.ownerId ||
        oldWidget.repository != widget.repository ||
        oldWidget.images != widget.images) {
      _reload();
    }
  }

  Future<void> _reload() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final auth = AuthService.instance;
      final owner = widget.ownerId ??
          (auth.isDemoMode.value ? 'demo' : auth.currentUser?.uid);
      final repo = widget.repository ??
          (owner == null
              ? null
              : WardrobeRepositoryFactory.forCurrentSession());
      final images = widget.images ??
          (owner == null
              ? null
              : WardrobeImageStoreFactory.forCurrentSession());
      final garments = repo == null || owner == null
          ? <ClothingItem>[]
          : await repo.listItems(owner);
      if (!mounted) return;
      setState(() {
        _ownerId = owner;
        _repository = repo;
        _images = images;
        _items = garments;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Dolabın yüklenemedi. Tekrar dene.';
      });
    }
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _openEditor([ClothingItem? item]) async {
    final repo = _repository;
    final images = _images;
    final owner = _ownerId;
    if (repo == null || images == null || owner == null || _busy) return;
    // A success snackbar from the previous save otherwise covers the editor's
    // fixed bottom action when the user opens another item immediately.
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => ClothingItemEditorScreen(
          ownerId: owner,
          repository: repo,
          images: images,
          existing: item,
          pickPhoto: widget.pickPhoto,
        ),
      ),
    );
    if (changed == true && mounted) {
      await _reload();
      _message(item == null ? 'Kıyafet dolabına eklendi.' : 'Kıyafet güncellendi.');
    }
  }

  Future<void> _deleteItem(ClothingItem item) async {
    if (_busy) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Kıyafet silinsin mi?'),
        content: Text('${item.name} dolabından kaldırılacak.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final repo = _repository;
    final images = _images;
    if (repo == null || images == null) return;
    setState(() => _busy = true);
    try {
      await repo.deleteItem(item.ownerId, item.id);
      var photoCleanupFailed = false;
      if (item.photoPath != null) {
        try {
          await images.delete(ownerId: item.ownerId, itemId: item.id);
        } catch (_) {
          photoCleanupFailed = true;
        }
      }
      await _reload();
      _message(photoCleanupFailed
          ? 'Kıyafet silindi; fotoğraf temizlenemedi.'
          : 'Kıyafet silindi.');
    } catch (_) {
      _message('Kıyafet silinemedi. Tekrar dene.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _toggleFavorite(ClothingItem item) async {
    if (_busy || _repository == null) return;
    setState(() => _busy = true);
    try {
      await _repository!.saveItem(item.copyWith(
        isFavorite: !item.isFavorite,
        updatedAt: DateTime.now().toUtc(),
      ));
      await _reload();
    } catch (_) {
      _message('Favori değişikliği kaydedilemedi.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _toggleLaundryStatus(ClothingItem item) async {
    if (_busy || _repository == null) return;
    setState(() => _busy = true);
    try {
      final next = item.laundryStatus == LaundryStatus.clean
          ? LaundryStatus.dirty
          : LaundryStatus.clean;
      await _repository!.saveItem(item.copyWith(
        laundryStatus: next,
        updatedAt: DateTime.now().toUtc(),
      ));
      await _reload();
    } catch (_) {
      _message('Çamaşır durumu kaydedilemedi.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  List<ClothingItem> get _filtered {
    final query = _search.trim().toLowerCase();
    return _items.where((item) {
      if (_selectedCategory != null && item.category != _selectedCategory) {
        return false;
      }
      if (_onlyFavorites && !item.isFavorite) return false;
      if (_laundryFilter != null && item.laundryStatus != _laundryFilter) {
        return false;
      }
      return query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.color.toLowerCase().contains(query) ||
          (item.brand?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  Widget _thumbnail(ClothingItem item) {
    final images = _images;
    if (item.photoPath == null || images == null) {
      return const Icon(Icons.checkroom_outlined, size: 30);
    }
    return FutureBuilder<Uint8List?>(
      future: images.read(ownerId: item.ownerId, itemId: item.id),
      builder: (context, snapshot) {
        final bytes = snapshot.data;
        if (bytes == null || bytes.isEmpty) {
          return const Icon(Icons.checkroom_outlined, size: 30);
        }
        return Image.memory(bytes, width: 56, height: 56, fit: BoxFit.cover);
      },
    );
  }

  Widget _emptyState() {
    final theme = Theme.of(context);
    final canAdd = _repository != null && _ownerId != null;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 350),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.checkroom_rounded,
                size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: AppSpacing.md),
            Text('Dolabın henüz boş',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text(
              canAdd
                  ? 'İlk kıyafetini ekleyerek dijital gardırobunu oluşturmaya başla.'
                  : 'Dolabını kullanmak için giriş yap veya demo modunu aç.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            if (canAdd) ...[
              const SizedBox(height: AppSpacing.md),
              TextButton.icon(
                onPressed: _busy ? null : () => _openEditor(),
                icon: const Icon(Icons.add_rounded),
                label: const Text('İlk Kıyafetini Ekle'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final visible = _filtered;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dolabım'),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Dolabı yenile',
            onPressed: _loading ? null : _reload,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: _repository == null || _ownerId == null
          ? null
          : FloatingActionButton.extended(
              key: const ValueKey('add-garment'),
              onPressed: _busy ? null : () => _openEditor(),
              icon: const Icon(Icons.add),
              label: const Text('Kıyafet Ekle'),
            ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: TextButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: Text(_error!),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_items.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0,
                          ),
                          child: Text(
                            'Temiz: ${_items.where((item) => item.laundryStatus == LaundryStatus.clean).length} · '
                            'Kirli: ${_items.where((item) => item.laundryStatus == LaundryStatus.dirty).length}',
                            key: const ValueKey('laundry-counts'),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0,
                          ),
                          child: TextField(
                            key: const ValueKey('wardrobe-search'),
                            onChanged: (value) =>
                                setState(() => _search = value),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Kıyafet, renk veya marka ara',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          child: Wrap(
                            spacing: AppSpacing.sm,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text('Çamaşır durumu:'),
                              ChoiceChip(
                                key: const ValueKey('laundry-filter-clean'),
                                label: const Text('Temiz'),
                                selected: _laundryFilter == LaundryStatus.clean,
                                onSelected: (value) => setState(() {
                                  _laundryFilter =
                                      value ? LaundryStatus.clean : null;
                                }),
                              ),
                              ChoiceChip(
                                key: const ValueKey('laundry-filter-dirty'),
                                label: const Text('Kirli'),
                                selected: _laundryFilter == LaundryStatus.dirty,
                                onSelected: (value) => setState(() {
                                  _laundryFilter =
                                      value ? LaundryStatus.dirty : null;
                                }),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 54,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: const Text('Favoriler'),
                                  selected: _onlyFavorites,
                                  onSelected: (value) =>
                                      setState(() => _onlyFavorites = value),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: const Text('Tümü'),
                                  selected: _selectedCategory == null,
                                  onSelected: (_) =>
                                      setState(() => _selectedCategory = null),
                                ),
                              ),
                              ...ClothingCategory.values.map(
                                (category) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ChoiceChip(
                                    label: Text(category.label),
                                    selected: _selectedCategory == category,
                                    onSelected: (_) => setState(
                                      () => _selectedCategory = category,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      Expanded(
                        child: _items.isEmpty
                            ? _emptyState()
                            : visible.isEmpty
                                ? const Center(
                                    child: Text('Filtrelere uygun kıyafet bulunamadı.'),
                                  )
                                : ListView.separated(
                                    padding: const EdgeInsets.fromLTRB(
                                      AppSpacing.md, AppSpacing.xs,
                                      AppSpacing.md, AppSpacing.huge,
                                    ),
                                    itemCount: visible.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: AppSpacing.sm),
                                    itemBuilder: (context, index) {
                                      final item = visible[index];
                                      return Card(
                                        key: ValueKey('wardrobe-item-${item.id}'),
                                        child: ListTile(
                                          onTap: _busy ? null
                                              : () => _openEditor(item),
                                          leading: SizedBox(
                                            height: 56, width: 56,
                                            child: ClipRRect(
                                              borderRadius: AppRadius.roundedSm,
                                              child: ColoredBox(
                                                color: colors.primaryContainer,
                                                child: Center(
                                                  child: _thumbnail(item),
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text(item.name),
                                          subtitle: Text(
                                            '${item.category.label} · ${item.color} · ${item.laundryStatus.label}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                key: ValueKey('toggle-laundry-${item.id}'),
                                                tooltip: item.laundryStatus == LaundryStatus.clean
                                                    ? 'Kirli İşaretle'
                                                    : 'Temiz İşaretle',
                                                onPressed: _busy ? null
                                                    : () => _toggleLaundryStatus(item),
                                                icon: Icon(
                                                  item.laundryStatus == LaundryStatus.clean
                                                      ? Icons.local_laundry_service_outlined
                                                      : Icons.check_circle_outline,
                                                  color: item.laundryStatus == LaundryStatus.dirty
                                                      ? colors.error : null,
                                                ),
                                              ),
                                              IconButton(
                                                tooltip: item.isFavorite
                                                    ? 'Favorilerden çıkar'
                                                    : 'Favorilere ekle',
                                                onPressed: _busy ? null
                                                    : () => _toggleFavorite(item),
                                                icon: Icon(
                                                  item.isFavorite
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: item.isFavorite
                                                      ? colors.primary : null,
                                                ),
                                              ),
                                              PopupMenuButton<String>(
                                                tooltip: 'Kıyafet işlemleri',
                                                enabled: !_busy,
                                                onSelected: (choice) {
                                                  if (choice == 'edit') {
                                                    _openEditor(item);
                                                  } else if (choice == 'delete') {
                                                    _deleteItem(item);
                                                  }
                                                },
                                                itemBuilder: (_) => const [
                                                  PopupMenuItem(
                                                    value: 'edit',
                                                    child: Text('Düzenle'),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 'delete',
                                                    child: Text('Sil'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
