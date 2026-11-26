/// Typed metadata for a single garment owned by one SmartClothes user.
///
/// Photo bytes live in private Firebase Storage, not inside Firestore or local
/// preferences. The stored [photoPath] is an internal Storage object path.
enum ClothingCategory {
  tops, bottoms, outerwear, dresses, shoes, accessories, other
}

enum ClothingSeason { spring, summer, autumn, winter }

enum ClothingOccasion { everyday, work, formal, sport, travel }

class ClothingItem {
  const ClothingItem({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.category,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
    this.seasons = const <ClothingSeason>{},
    this.occasions = const <ClothingOccasion>{},
    this.brand,
    this.notes,
    this.photoPath,
    this.isFavorite = false,
  });

  final String id;
  final String ownerId;
  final String name;
  final ClothingCategory category;
  final String color;
  final Set<ClothingSeason> seasons;
  final Set<ClothingOccasion> occasions;
  final String? brand;
  final String? notes;
  final String? photoPath;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// A single JSON shape works in local storage and Firestore.
  Map<String, dynamic> toJson() => {
        'id': id,
        'ownerId': ownerId,
        'name': name,
        'category': category.name,
        'color': color,
        'seasons': seasons.map((season) => season.name).toList()..sort(),
        'occasions': occasions.map((occasion) => occasion.name).toList()..sort(),
        'brand': brand,
        'notes': notes,
        'photoPath': photoPath,
        'isFavorite': isFavorite,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'updatedAt': updatedAt.millisecondsSinceEpoch,
      };

  factory ClothingItem.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final ownerId = json['ownerId'];
    final name = json['name'];
    final color = json['color'];
    final createdAt = json['createdAt'];
    final updatedAt = json['updatedAt'];
    if (id is! String || id.isEmpty ||
        ownerId is! String || ownerId.isEmpty ||
        name is! String || name.trim().isEmpty ||
        color is! String || color.trim().isEmpty ||
        createdAt is! num || updatedAt is! num) {
      throw const FormatException('Invalid clothing item metadata');
    }

    final categoryName = json['category'];
    final category = ClothingCategory.values.firstWhere(
      (item) => item.name == categoryName,
      orElse: () => ClothingCategory.other,
    );

    return ClothingItem(
      id: id,
      ownerId: ownerId,
      name: name,
      category: category,
      color: color,
      seasons: _parseEnumSet(
        json['seasons'],
        ClothingSeason.values,
        (value) => value.name,
      ),
      occasions: _parseEnumSet(
        json['occasions'],
        ClothingOccasion.values,
        (value) => value.name,
      ),
      brand: json['brand'] is String ? json['brand'] as String : null,
      notes: json['notes'] is String ? json['notes'] as String : null,
      photoPath: json['photoPath'] is String ? json['photoPath'] as String : null,
      isFavorite: json['isFavorite'] == true,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt.toInt(), isUtc: true),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt.toInt(), isUtc: true),
    );
  }

  static Set<T> _parseEnumSet<T>(
    dynamic value,
    List<T> choices,
    String Function(T) name,
  ) {
    if (value is! List) return <T>{};
    final names = value.whereType<String>().toSet();
    return choices.where((choice) => names.contains(name(choice))).toSet();
  }

  ClothingItem copyWith({
    String? name,
    ClothingCategory? category,
    String? color,
    Set<ClothingSeason>? seasons,
    Set<ClothingOccasion>? occasions,
    String? brand,
    String? notes,
    String? photoPath,
    bool? isFavorite,
    DateTime? updatedAt,
  }) {
    return ClothingItem(
      id: id,
      ownerId: ownerId,
      name: name ?? this.name,
      category: category ?? this.category,
      color: color ?? this.color,
      seasons: seasons ?? this.seasons,
      occasions: occasions ?? this.occasions,
      brand: brand ?? this.brand,
      notes: notes ?? this.notes,
      photoPath: photoPath ?? this.photoPath,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
