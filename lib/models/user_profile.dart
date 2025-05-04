class UserProfile {
  final int id;
  final String name;
  final String email;

  const UserProfile({this.id = 0, required this.name, required this.email});

  Map<String, dynamic> toMap() => {
    'id': id != 0 ? id : null,
    'name': name,
    'email': email,
  };

  static UserProfile fromMap(Map<String, dynamic> map) => UserProfile(
    id: map['id'] ?? 0,
    name: map['name'] ?? '',
    email: map['email'] ?? '',
  );

  UserProfile copyWith({int? id, String? name, String? email}) => UserProfile(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
  );
}