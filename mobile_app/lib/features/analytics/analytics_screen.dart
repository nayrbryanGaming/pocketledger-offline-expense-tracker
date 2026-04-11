import 'package:fl_chart/fl_chart.dart';
import '../../services/providers.dart';
import 'budget_progress_widget.dart';
import '../../data/models/budget.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spending Analytics', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          if (transactions.isEmpty) return _buildEmptyState();
          
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Monthly Budgets'),
                const SizedBox(height: 16),
                _buildBudgetList(ref, transactions),
                const SizedBox(height: 32),
                _buildSectionHeader('Category Breakdown'),
                const SizedBox(height: 24),
                _buildCategoryPieChart(transactions, categoriesAsync),
                const SizedBox(height: 48),
                _buildSectionHeader('Spending Trend'),
                const SizedBox(height: 24),
                _buildTrendLineChart(transactions),
                const SizedBox(height: 48),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(child: Text('No data to analyze. Add transactions first!'));
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _buildBudgetList(WidgetRef ref, List transactions) {
     final categoriesAsync = ref.watch(categoriesProvider);
     
     return categoriesAsync.when(
       data: (categories) {
         final expenseTransactions = transactions.where((t) => t.type == 'expense');
         
         return Column(
           children: categories.where((c) => c.id != 6).map((cat) { // Skip "Salary" for budgeting
             final spent = expenseTransactions
                 .where((t) => t.categoryId == cat.id)
                 .fold(0.0, (sum, t) => sum + t.amount);
             
             // Demo: Default limit of 1M if not set
             return BudgetProgressWidget(
               category: cat,
               spent: spent,
               limit: 1000000, 
             );
           }).toList(),
         );
       },
       loading: () => const LinearProgressIndicator(),
       error: (e, st) => Text('Error: $e'),
     );
  }

  Widget _buildCategoryPieChart(List transactions, AsyncValue categoriesAsync) {
    // Logic to group expenses by category
    final expenses = transactions.where((t) => t.type == 'expense').toList();
    final Map<int, double> catMap = {};
    for (var t in expenses) {
      catMap[t.categoryId] = (catMap[t.categoryId] ?? 0) + t.amount;
    }

    return categoriesAsync.when(
      data: (categories) {
        final sections = catMap.entries.map((e) {
          final cat = categories.firstWhere((c) => c.id == e.key);
          return PieChartSectionData(
            value: e.value,
            title: '${e.value.toStringAsFixed(0)}',
            color: _parseColor(cat.color),
            radius: 50,
            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          );
        }).toList();

        return SizedBox(
          height: 200,
          child: PieChart(PieChartData(sections: sections, sectionsSpace: 4, centerSpaceRadius: 40)),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, st) => Text('Error loading chart'),
    );
  }

  Widget _buildTrendLineChart(List transactions) {
     // For demo simplicity, just a static trend placeholder with real-ish logic
     return Container(
       height: 200,
       padding: const EdgeInsets.only(right: 16, top: 16),
       child: LineChart(
         LineChartData(
           gridData: FlGridData(show: false),
           titlesData: FlTitlesData(show: false),
           borderData: FlBorderData(show: false),
           lineBarsData: [
             LineChartBarData(
               spots: const [
                 FlSpot(0, 1),
                 FlSpot(1, 3),
                 FlSpot(2, 2.5),
                 FlSpot(3, 4),
                 FlSpot(4, 3.5),
               ],
               isCurved: true,
               color: const Color(0xFF10B981),
               barWidth: 4,
               belowBarData: BarAreaData(show: true, color: const Color(0xFF10B981).withOpacity(0.1)),
             ),
           ],
         ),
       ),
     );
  }

  Color _parseColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }
}
