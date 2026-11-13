/// The broad clothing styles a user wants to see in future recommendations.
enum ClothingStyle { minimal, classic, streetwear, casual, sporty, elegant }

extension ClothingStyleDetails on ClothingStyle {
  String get label => switch (this) {
        ClothingStyle.minimal => 'Minimal',
        ClothingStyle.classic => 'Klasik',
        ClothingStyle.streetwear => 'Streetwear',
        ClothingStyle.casual => 'Günlük',
        ClothingStyle.sporty => 'Sportif',
        ClothingStyle.elegant => 'Şık',
      };

  String get description => switch (this) {
        ClothingStyle.minimal => 'Sade ve zamansız parçalar',
        ClothingStyle.classic => 'Düzenli, klasik kombinler',
        ClothingStyle.streetwear => 'Rahat ve şehirli görünüm',
        ClothingStyle.casual => 'Günlük ve konforlu stil',
        ClothingStyle.sporty => 'Dinamik, sportif parçalar',
        ClothingStyle.elegant => 'Özenli ve şık tercihler',
      };
}

/// Shopping budget is a preference, not a promise about live product prices.
enum ShoppingBudget { economic, medium, premium, unlimited }

extension ShoppingBudgetDetails on ShoppingBudget {
  String get label => switch (this) {
        ShoppingBudget.economic => 'Ekonomik',
        ShoppingBudget.medium => 'Orta',
        ShoppingBudget.premium => 'Premium',
        ShoppingBudget.unlimited => 'Sınır yok',
      };

  String get description => switch (this) {
        ShoppingBudget.economic => 'Uygun fiyatlı parçalar',
        ShoppingBudget.medium => 'Fiyat ve kalite dengesi',
        ShoppingBudget.premium => 'Üst segment seçenekler',
        ShoppingBudget.unlimited => 'Bütçemi sınırlamak istemiyorum',
      };
}

/// Local onboarding preferences. Empty choices are valid when onboarding was
/// intentionally skipped; [isComplete] prevents showing onboarding each time.
class UserPreferences {
  const UserPreferences({
    this.styles = const <ClothingStyle>{},
    this.budget,
    this.isComplete = false,
  });

  final Set<ClothingStyle> styles;
  final ShoppingBudget? budget;
  final bool isComplete;

  Map<String, dynamic> toJson() => {
        'styles': styles.map((style) => style.name).toList()..sort(),
        'budget': budget?.name,
        'isComplete': isComplete,
      };

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    final rawStyles = json['styles'];
    final styleNames = rawStyles is List
        ? rawStyles.whereType<String>().toSet()
        : <String>{};
    final budgetName = json['budget'];

    ShoppingBudget? parsedBudget;
    for (final item in ShoppingBudget.values) {
      if (item.name == budgetName) {
        parsedBudget = item;
        break;
      }
    }

    return UserPreferences(
      styles: ClothingStyle.values
          .where((style) => styleNames.contains(style.name))
          .toSet(),
      budget: parsedBudget,
      isComplete: json['isComplete'] == true,
    );
  }
}
