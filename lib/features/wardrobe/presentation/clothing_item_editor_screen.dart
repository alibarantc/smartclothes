import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartclothes/core/constants/app_constants.dart';
import 'package:smartclothes/features/wardrobe/models/clothing_item.dart';
import 'package:smartclothes/features/wardrobe/models/clothing_labels.dart';
import 'package:smartclothes/features/wardrobe/repositories/wardrobe_repository.dart';
import 'package:smartclothes/features/wardrobe/services/wardrobe_image_store.dart';
import 'package:smartclothes/features/wardrobe/services/wardrobe_photo_service.dart';

/// One selected, validated photo. No image bytes enter SharedPreferences.
class PickedWardrobePhoto {
  const PickedWardrobePhoto({required this.bytes, required this.contentType});
  final Uint8List bytes;
  final String contentType;
}

/// Form for adding or updating wardrobe items. The storage implementation is
/// injected so demo items persist locally while authenticated items use cloud.
class ClothingItemEditorScreen extends StatefulWidget {
  const ClothingItemEditorScreen({
    super.key,
    required this.ownerId,
    required this.repository,
    required this.images,
    this.existing,
    this.pickPhoto,
  });

  final String ownerId;
  final WardrobeRepository repository;
  final WardrobeImageStore images;
  final ClothingItem? existing;
  final Future<PickedWardrobePhoto?> Function()? pickPhoto;

  @override
  State<ClothingItemEditorScreen> createState() =>
      _ClothingItemEditorScreenState();
}

class _ClothingItemEditorScreenState extends State<ClothingItemEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _colorController;
  late final TextEditingController _brandController;
  late final TextEditingController _notesController;
  late ClothingCategory _category;
  late Set<ClothingSeason> _seasons;
  late Set<ClothingOccasion> _occasions;
  late bool _isFavorite;
  late LaundryStatus _laundryStatus;
  bool _saving = false;
  bool _removePhoto = false;
  PickedWardrobePhoto? _newPhoto;
  Future<Uint8List?>? _existingPhoto;

  @override
  void initState() {
    super.initState();
    final old = widget.existing;
    _nameController = TextEditingController(text: old?.name ?? '');
    _colorController = TextEditingController(text: old?.color ?? '');
    _brandController = TextEditingController(text: old?.brand ?? '');
    _notesController = TextEditingController(text: old?.notes ?? '');
    _category = old?.category ?? ClothingCategory.tops;
    _seasons = {...?old?.seasons};
    _occasions = {...?old?.occasions};
    _isFavorite = old?.isFavorite ?? false;
    _laundryStatus = old?.laundryStatus ?? LaundryStatus.clean;
    if (old?.photoPath != null) {
      _existingPhoto = widget.images.read(
        ownerId: widget.ownerId, itemId: old!.id,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    _brandController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _message(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  String? _required(String? value, {int maxLength = 120}) {
    if (value == null || value.trim().isEmpty) return 'Bu alan zorunlu';
    if (value.trim().length > maxLength) return 'En fazla $maxLength karakter';
    return null;
  }

  Future<void> _choosePhoto() async {
    if (_saving) return;
    try {
      PickedWardrobePhoto? photo;
      if (widget.pickPhoto != null) {
        photo = await widget.pickPhoto!();
      } else {
        final picked = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxWidth: 1600,
          maxHeight: 1600,
          imageQuality: 85,
        );
        if (picked == null) return;
        final filename = picked.name.toLowerCase();
        final mime = filename.endsWith('.png')
            ? 'image/png'
            : filename.endsWith('.webp')
                ? 'image/webp'
                : filename.endsWith('.jpg') || filename.endsWith('.jpeg')
                    ? 'image/jpeg'
                    : '';
        if (mime.isEmpty) {
          if (mounted) _message('Yalnızca JPG, PNG veya WebP fotoğraf seç.');
          return;
        }
        photo = PickedWardrobePhoto(
          bytes: await picked.readAsBytes(), contentType: mime,
        );
      }
      if (photo == null || !mounted) return;
      if (photo.bytes.isEmpty ||
          photo.bytes.lengthInBytes > WardrobePhotoService.maxPhotoBytes ||
          !const {'image/jpeg', 'image/png', 'image/webp'}
              .contains(photo.contentType)) {
        _message('Fotoğraf JPG, PNG veya WebP olmalı ve 8 MB\'ı aşmamalı.');
        return;
      }
      setState(() {
        _newPhoto = photo;
        _removePhoto = false;
      });
    } catch (_) {
      if (mounted) _message('Fotoğraf seçilemedi. Tekrar dene.');
    }
  }

  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final previous = widget.existing;
    final now = DateTime.now().toUtc();
    final id = previous?.id ??
        'item_${now.microsecondsSinceEpoch}';
    String? photoPath = _removePhoto ? null : previous?.photoPath;
    bool newPhotoStored = false;
    try {
      if (_newPhoto != null) {
        photoPath = await widget.images.save(
          ownerId: widget.ownerId,
          itemId: id,
          bytes: _newPhoto!.bytes,
          contentType: _newPhoto!.contentType,
        );
        newPhotoStored = true;
      }

      final garment = ClothingItem(
        id: id,
        ownerId: widget.ownerId,
        name: _nameController.text.trim(),
        category: _category,
        color: _colorController.text.trim(),
        brand: _brandController.text.trim().isEmpty
            ? null : _brandController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null : _notesController.text.trim(),
        photoPath: photoPath,
        seasons: _seasons,
        occasions: _occasions,
        isFavorite: _isFavorite,
        laundryStatus: _laundryStatus,
        createdAt: previous?.createdAt ?? now,
        updatedAt: now,
      );
      await widget.repository.saveItem(garment);
      if (_removePhoto && previous?.photoPath != null && _newPhoto == null) {
        try {
          await widget.images.delete(ownerId: widget.ownerId, itemId: id);
        } catch (_) {
          // Metadata has been saved; orphan cleanup can be retried on delete.
        }
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      // Only a newly created record can safely be rolled back; replacement
      // photos retain their existing owner-scoped path and may have changed.
      if (previous == null && newPhotoStored) {
        try {
          await widget.images.delete(ownerId: widget.ownerId, itemId: id);
        } catch (_) {
          // Best-effort cleanup for a failed initial metadata write.
        }
      }
      if (mounted) _message('Kıyafet kaydedilemedi. Tekrar dene.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _photoPreview() {
    if (_newPhoto != null) {
      return Image.memory(_newPhoto!.bytes,
          width: 104, height: 104, fit: BoxFit.cover);
    }
    if (_removePhoto || _existingPhoto == null) {
      return const Icon(Icons.add_a_photo_outlined, size: 44);
    }
    return FutureBuilder<Uint8List?>(
      future: _existingPhoto,
      builder: (context, snapshot) {
        final bytes = snapshot.data;
        if (bytes != null && bytes.isNotEmpty) {
          return Image.memory(bytes, width: 104, height: 104, fit: BoxFit.cover);
        }
        return const Icon(Icons.photo_outlined, size: 44);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.existing == null
          ? 'Kıyafet Ekle' : 'Kıyafeti Düzenle')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: AppRadius.roundedLg,
                              child: SizedBox(
                                width: 104, height: 104,
                                child: ColoredBox(
                                  color: theme.colorScheme.primaryContainer,
                                  child: Center(child: _photoPreview()),
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _saving ? null : _choosePhoto,
                              icon: const Icon(Icons.photo_library_outlined),
                              label: const Text('Fotoğraf Seç'),
                            ),
                            if (_newPhoto != null ||
                                (widget.existing?.photoPath != null &&
                                    !_removePhoto))
                              TextButton(
                                onPressed: _saving ? null : () {
                                  setState(() {
                                    _newPhoto = null;
                                    _removePhoto = true;
                                  });
                                },
                                child: const Text('Fotoğrafı Kaldır'),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        key: const ValueKey('garment-name'),
                        controller: _nameController,
                        maxLength: 120,
                        decoration: const InputDecoration(
                          labelText: 'Kıyafet adı *',
                          hintText: 'Beyaz pamuklu tişört',
                        ),
                        validator: (value) => _required(value),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      DropdownButtonFormField<ClothingCategory>(
                        key: const ValueKey('garment-category'),
                        value: _category,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'Kategori'),
                        items: ClothingCategory.values.map((category) =>
                            DropdownMenuItem(
                              value: category, child: Text(category.label),
                            )).toList(),
                        onChanged: _saving ? null : (value) {
                          if (value != null) setState(() => _category = value);
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        key: const ValueKey('garment-color'),
                        controller: _colorController,
                        maxLength: 60,
                        decoration: const InputDecoration(
                          labelText: 'Renk *', hintText: 'Ekru',
                        ),
                        validator: (value) => _required(value, maxLength: 60),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: _brandController,
                        maxLength: 120,
                        decoration: const InputDecoration(
                          labelText: 'Marka (isteğe bağlı)',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: _notesController,
                        maxLength: 1000,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Not (isteğe bağlı)',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text('Mevsim', style: theme.textTheme.titleSmall),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.sm, runSpacing: AppSpacing.xs,
                        children: ClothingSeason.values.map((season) =>
                            FilterChip(
                              label: Text(season.label),
                              selected: _seasons.contains(season),
                              onSelected: _saving ? null : (chosen) {
                                setState(() {
                                  if (chosen) {
                                    _seasons.add(season);
                                  } else {
                                    _seasons.remove(season);
                                  }
                                });
                              },
                            )).toList(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text('Kullanım alanı', style: theme.textTheme.titleSmall),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.sm, runSpacing: AppSpacing.xs,
                        children: ClothingOccasion.values.map((occasion) =>
                            FilterChip(
                              label: Text(occasion.label),
                              selected: _occasions.contains(occasion),
                              onSelected: _saving ? null : (chosen) {
                                setState(() {
                                  if (chosen) {
                                    _occasions.add(occasion);
                                  } else {
                                    _occasions.remove(occasion);
                                  }
                                });
                              },
                            )).toList(),
                      ),
                      SwitchListTile(
                        key: const ValueKey('garment-laundry-status'),
                        title: const Text('Bu kıyafet kirli'),
                        subtitle: const Text(
                          'Kirli kıyafetler kombin adaylarında kullanılmaz.',
                        ),
                        value: _laundryStatus == LaundryStatus.dirty,
                        onChanged: _saving ? null : (value) => setState(() {
                          _laundryStatus =
                              value ? LaundryStatus.dirty : LaundryStatus.clean;
                        }),
                      ),
                      SwitchListTile(
                        title: const Text('Favorilerime ekle'),
                        value: _isFavorite,
                        onChanged: _saving ? null
                            : (value) => setState(() => _isFavorite = value),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: const ValueKey('save-garment'),
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(widget.existing == null
                            ? 'Kıyafeti Kaydet' : 'Değişiklikleri Kaydet'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
