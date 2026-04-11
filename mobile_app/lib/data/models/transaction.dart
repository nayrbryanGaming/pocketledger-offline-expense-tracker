class AppTransaction {
  final int? id;
  final String title;
  final double amount;
  final String type; // 'expense' or 'income'
  final int categoryId;
  final DateTime date;
  final String note;

  AppTransaction({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    this.note = '',
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'category_id': categoryId,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  factory AppTransaction.fromMap(Map<String, dynamic> map) {
    return AppTransaction(
      id: map['id']?.toInt(),
      title: map['title'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      type: map['type'] ?? 'expense',
      categoryId: map['category_id']?.toInt() ?? 0,
      date: DateTime.parse(map['date']),
      note: map['note'] ?? '',
    );
  }

  AppTransaction copyWith({
    int? id,
    String? title,
    double? amount,
    String? type,
    int? categoryId,
    DateTime? date,
    String? note,
  }) {
    return AppTransaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }
}
