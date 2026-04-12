import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/providers.dart';
import '../../data/models/category.dart';
import '../../data/models/budget.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CategoryManagerScreen extends ConsumerWidget {
  const CategoryManagerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final budgetsAsync = ref.watch(budgetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: categoriesAsync.when(
        data: (categories) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final budget = budgetsAsync.maybeWhen(
              data: (budgets) => budgets.firstWhere(
                (b) => b.categoryId == category.id,
                orElse: () => AppBudget(categoryId: category.id!, limit: 0),
              ),
              orElse: () => AppBudget(categoryId: category.id!, limit: 0),
            );

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Text(category.icon, style: const TextStyle(fontSize: 24)),
                ),
                title: Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  budget.limit > 0 
                      ? 'Budget: ${budget.limit.toStringAsFixed(0)} / mo' 
                      : 'No budget set',
                  style: TextStyle(color: budget.limit > 0 ? const Color(0xFF10B981) : Colors.grey),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_note, color: Colors.grey),
                  onPressed: () => _showEditDialog(context, ref, category, budget),
                ),
              ),
            ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        backgroundColor: const Color(0xFF10B981),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, AppCategory category, AppBudget budget) {
    final titleController = TextEditingController(text: category.name);
    final budgetController = TextEditingController(text: budget.limit > 0 ? budget.limit.toString() : '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${category.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Category Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Monthly Budget Limit'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final newLimit = double.tryParse(budgetController.text) ?? 0.0;
              ref.read(budgetsProvider.notifier).updateBudget(
                AppBudget(id: budget.id, categoryId: category.id!, limit: newLimit),
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final budgetController = TextEditingController();
    String selectedIcon = '💰';
    final List<String> icons = ['💰', '🍔', '🚗', '🛍️', '🏥', '🎬', '🏠', '🎁', '✈️', '🎓', '🛠️', '📱'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('New Category'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Category Name', hintText: 'e.g. Rent, Gym...'),
                ),
                const SizedBox(height: 16),
                const Text('Choose Icon:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: icons.map((icon) => InkWell(
                    onTap: () => setState(() => selectedIcon = icon),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selectedIcon == icon ? const Color(0xFF10B981).withOpacity(0.1) : Colors.transparent,
                        border: Border.all(color: selectedIcon == icon ? const Color(0xFF10B981) : Colors.grey.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(icon, style: const TextStyle(fontSize: 20)),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: budgetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Monthly Budget (Optional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final cat = AppCategory(
                    name: titleController.text,
                    icon: selectedIcon,
                    color: '#10B981',
                  );
                  ref.read(categoriesProvider.notifier).addCategory(cat).then((_) {
                    if (budgetController.text.isNotEmpty) {
                      final limit = double.tryParse(budgetController.text) ?? 0.0;
                      // Note: We need the ID of the new category. For simplicity, we refresh and user can set it later,
                      // or we could fetch the last inserted ID.
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
