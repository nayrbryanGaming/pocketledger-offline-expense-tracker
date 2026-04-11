class AppBudget {
  final int? id;
  final int categoryId;
  final double limit;

  AppBudget({
    this.id,
    required this.categoryId,
    required this.limit,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'category_id': categoryId,
      'monthly_limit': limit,
    };
  }

  factory AppBudget.fromMap(Map<String, dynamic> map) {
    return AppBudget(
      id: map['id']?.toInt(),
      categoryId: map['category_id']?.toInt() ?? 0,
      limit: map['monthly_limit']?.toDouble() ?? 0.0,
    );
  }
}
