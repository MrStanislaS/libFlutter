class RecipeStep {
  final int id;
  final int recipeId;
  final int stepNumber;
  final String description;

  const RecipeStep({
    this.id = 0,
    this.recipeId = 0,
    required this.stepNumber,
    required this.description,
  }) : assert(stepNumber > 0, 'Step number must be greater than 0');

  Map<String, dynamic> toMap() {
    return {
      'id': id != 0 ? id : null,
      'recipeId': recipeId,
      'stepNumber': stepNumber,
      'description': description,
    };
  }

  static RecipeStep fromMap(Map<String, dynamic> map) {
    return RecipeStep(
      id: map['id'] ?? 0,
      recipeId: map['recipeId'] ?? 0,
      stepNumber: map['stepNumber'] ?? 1,
      description: map['description'] ?? '',
    );
  }

  RecipeStep copyWith({
    int? id,
    int? recipeId,
    int? stepNumber,
    String? description,
  }) {
    return RecipeStep(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      stepNumber: stepNumber ?? this.stepNumber,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecipeStep &&
        other.id == id &&
        other.recipeId == recipeId &&
        other.stepNumber == stepNumber &&
        other.description == description;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      recipeId.hashCode ^
      stepNumber.hashCode ^
      description.hashCode;

  @override
  String toString() =>
      'RecipeStep(id: $id, recipeId: $recipeId, stepNumber: $stepNumber, description: $description)';
}
