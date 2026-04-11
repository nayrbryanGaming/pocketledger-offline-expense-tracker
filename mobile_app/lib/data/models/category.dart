class AppCategory {
  final int? id;
  final String name;
  final String icon;
  final String color;

  AppCategory({
    this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'icon': icon,
      'color': color,
    };
  }

  factory AppCategory.fromMap(Map<String, dynamic> map) {
    return AppCategory(
      id: map['id']?.toInt(),
      name: map['name'] ?? 'General',
      icon: map['icon'] ?? '💰',
      color: map['color'] ?? '#10B981',
    );
  }

  AppCategory copyWith({
    int? id,
    String? name,
    String? icon,
    String? color,
  }) {
    return AppCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }
}
