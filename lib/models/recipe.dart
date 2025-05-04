import 'ingredient.dart';
import 'step.dart';

/// Représente le niveau de difficulté d'une recette
enum Difficulty {
  easy(1),
  medium(2),
  hard(3);

  final int value;
  const Difficulty(this.value);

  static Difficulty fromValue(int value) {
    return Difficulty.values.firstWhere(
      (difficulty) => difficulty.value == value,
      orElse: () => Difficulty.medium,
    );
  }
}

class Recipe {
  final int id;
  final String title;
  final String description;
  final int preparationTime; // en minutes
  final int cookingTime; // en minutes
  final int servings;
  final Difficulty difficulty;
  final String imageUrl;
  final bool isFavorite;
  final int categoryId;
  final List<Ingredient> ingredients;
  final List<RecipeStep> steps;

  const Recipe({
    this.id = 0,
    required this.title,
    required this.description,
    required this.preparationTime,
    required this.cookingTime,
    required this.servings,
    required this.difficulty,
    required this.imageUrl,
    this.isFavorite = false,
    required this.categoryId,
    required this.ingredients,
    required this.steps,
  })  : assert(preparationTime >= 0, 'Preparation time must be non-negative'),
        assert(cookingTime >= 0, 'Cooking time must be non-negative'),
        assert(servings > 0, 'Servings must be greater than 0');

  Map<String, dynamic> toMap() {
    return {
      'id': id != 0 ? id : null,
      'title': title,
      'description': description,
      'preparationTime': preparationTime,
      'cookingTime': cookingTime,
      'servings': servings,
      'difficulty': difficulty.value,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite ? 1 : 0,
      'categoryId': categoryId,
    };
  }

  static Recipe fromMap(
    Map<String, dynamic> map,
    List<Map<String, dynamic>> ingredientsMaps,
    List<Map<String, dynamic>> stepsMaps,
  ) {
    List<Ingredient> ingredients = ingredientsMaps
        .map((ingredientMap) => Ingredient.fromMap(ingredientMap))
        .toList();

    List<RecipeStep> steps = stepsMaps
        .map((stepMap) => RecipeStep.fromMap(stepMap))
        .toList();

    // Trier les étapes par numéro
    steps.sort((a, b) => a.stepNumber.compareTo(b.stepNumber));

    return Recipe(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      preparationTime: map['preparationTime'] ?? 0,
      cookingTime: map['cookingTime'] ?? 0,
      servings: map['servings'] ?? 1,
      difficulty: Difficulty.fromValue(map['difficulty'] ?? 2),
      imageUrl: map['imageUrl'] ?? '',
      isFavorite: (map['isFavorite'] ?? 0) == 1,
      categoryId: map['categoryId'] ?? 0,
      ingredients: ingredients,
      steps: steps,
    );
  }

  /// Retourne le temps total de préparation et cuisson en minutes
  int get totalTime => preparationTime + cookingTime;

  Recipe copyWith({
    int? id,
    String? title,
    String? description,
    int? preparationTime,
    int? cookingTime,
    int? servings,
    Difficulty? difficulty,
    String? imageUrl,
    bool? isFavorite,
    int? categoryId,
    List<Ingredient>? ingredients,
    List<RecipeStep>? steps,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      preparationTime: preparationTime ?? this.preparationTime,
      cookingTime: cookingTime ?? this.cookingTime,
      servings: servings ?? this.servings,
      difficulty: difficulty ?? this.difficulty,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      categoryId: categoryId ?? this.categoryId,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
    );
  }

  /// Crée une copie de la recette avec son statut favori inversé
  Recipe toggleFavorite() {
    return copyWith(isFavorite: !isFavorite);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Recipe &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.preparationTime == preparationTime &&
        other.cookingTime == cookingTime &&
        other.servings == servings &&
        other.difficulty == difficulty &&
        other.imageUrl == imageUrl &&
        other.isFavorite == isFavorite &&
        other.categoryId == categoryId &&
        _listEquals(other.ingredients, ingredients) &&
        _listEquals(other.steps, steps);
  }

  // Helper pour comparer les listes
  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    
    return true;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        preparationTime.hashCode ^
        cookingTime.hashCode ^
        servings.hashCode ^
        difficulty.hashCode ^
        imageUrl.hashCode ^
        isFavorite.hashCode ^
        categoryId.hashCode ^
        ingredients.hashCode ^
        steps.hashCode;
  }

  @override
  String toString() {
    return 'Recipe(id: $id, title: $title, difficulty: ${difficulty.name}, ' 
        'preparationTime: $preparationTime, cookingTime: $cookingTime, '
        'servings: $servings, isFavorite: $isFavorite, '
        'ingredients: ${ingredients.length}, steps: ${steps.length})';
  }
}
