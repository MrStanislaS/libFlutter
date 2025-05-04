class Categori {
  final int id;
  final String name;
  final int color;

  const Categori({
    this.id = 0,
    required this.name,
    required this.color,
  }) : assert(color >= 0, 'Color must be a positive integer');

  Map<String, dynamic> toMap() {
    return {
      'id': id != 0 ? id : null,
      'name': name,
      'color': color,
    };
  }

  static Categori fromMap(Map<String, dynamic> map) {
    return Categori(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      color: map['color'] ?? 0,
    );
  }

  Categori copyWith({
    int? id,
    String? name,
    int? color,
  }) {
    return Categori(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Categori &&
        other.id == id &&
        other.name == name &&
        other.color == color;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ color.hashCode;

  @override
  String toString() => 'Categori(id: $id, name: $name, color: $color)';
}
