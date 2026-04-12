class AppTransaction {
  final int? id;
  final String title;
  final double amount;
  final String type; // 'expense' or 'income'
  final int categoryId;
  final DateTime date;
  final String note;
  final bool isRecurring;
  final String? frequency; // 'daily', 'weekly', 'monthly'
  final DateTime? lastGeneratedDate;

  AppTransaction({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    this.note = '',
    this.isRecurring = false,
    this.frequency,
    this.lastGeneratedDate,
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
      'is_recurring': isRecurring ? 1 : 0,
      'frequency': frequency,
      'last_generated_date': lastGeneratedDate?.toIso8601String(),
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
      isRecurring: (map['is_recurring'] ?? 0) == 1,
      frequency: map['frequency'],
      lastGeneratedDate: map['last_generated_date'] != null 
          ? DateTime.parse(map['last_generated_date']) 
          : null,
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
    bool? isRecurring,
    String? frequency,
    DateTime? lastGeneratedDate,
  }) {
    return AppTransaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      note: note ?? this.note,
      isRecurring: isRecurring ?? this.isRecurring,
      frequency: frequency ?? this.frequency,
      lastGeneratedDate: lastGeneratedDate ?? this.lastGeneratedDate,
    );
  }
}
