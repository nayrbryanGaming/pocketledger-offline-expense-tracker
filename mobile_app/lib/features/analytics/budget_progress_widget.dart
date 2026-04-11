import 'package:flutter/material.dart';
import '../../data/models/category.dart';

class BudgetProgressWidget extends StatelessWidget {
  final AppCategory category;
  final double spent;
  final double limit;

  const BudgetProgressWidget({
    Key? key,
    required this.category,
    required this.spent,
    required this.limit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percent = (spent / limit).clamp(0.0, 1.0);
    final isOver = spent > limit;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(category.icon, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Text(
                'Rp ${spent.toStringAsFixed(0)} / Rp ${limit.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 12,
                  color: isOver ? Colors.red : Colors.grey,
                  fontWeight: isOver ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: Colors.grey.withOpacity(0.1),
              color: isOver ? Colors.red : const Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }
}
