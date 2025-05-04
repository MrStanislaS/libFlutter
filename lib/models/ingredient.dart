class Ingredient {
  final int id;
  final int recipeId;
  final String name;
  final double quantity;
  final String unit;

  const Ingredient({
    this.id = 0,
    this.recipeId = 0,
    required this.name,
    required this.quantity,
    required this.unit,
  }) : assert(quantity >= 0, 'Quantity must be a positive number');

  Map<String, dynamic> toMap() {
    return {
      'id': id != 0 ? id : null,
      'recipeId': recipeId,
      'name': name,
      'quantity': quantity,
      'unit': unit,
    };
  }

  static Ingredient fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['id'] ?? 0,
      recipeId: map['recipeId'] ?? 0,
      name: map['name'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      unit: map['unit'] ?? '',
    );
  }

  Ingredient copyWith({
    int? id,
    int? recipeId,
    String? name,
    double? quantity,
    String? unit,
  }) {
    return Ingredient(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Ingredient &&
        other.id == id &&
        other.recipeId == recipeId &&
        other.name == name &&
        other.quantity == quantity &&
        other.unit == unit;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      recipeId.hashCode ^
      name.hashCode ^
      quantity.hashCode ^
      unit.hashCode;

  @override
  String toString() =>
      'Ingredient(id: $id, recipeId: $recipeId, name: $name, quantity: $quantity, unit: $unit)';
}
