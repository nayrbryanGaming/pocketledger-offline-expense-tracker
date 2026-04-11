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
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
    };
  }

  factory AppCategory.fromMap(Map<String, dynamic> map) {
    return AppCategory(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      icon: map['icon'] ?? '',
      color: map['color'] ?? '',
    );
  }
}
