import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsyncValue = ref.watch(balanceProvider);
    final transactionsAsyncValue = ref.watch(transactionsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('PocketLedger', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text('Total Balance', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 4),
            balanceAsyncValue.when(
              data: (balance) => Text(
                'Rp ${balance.toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
              ),
              loading: () => const Text('Rp ...', style: TextStyle(color: Colors.white, fontSize: 36)),
              error: (e, st) => const Text('Error', style: TextStyle(color: Colors.red)),
            ),
            const SizedBox(height: 32),
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(24),
              ),
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text('D${value.toInt()}', style: const TextStyle(color: Colors.white54, fontSize: 10));
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10, color: const Color(0xFFEF4444))]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 5, color: const Color(0xFFEF4444))]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 20, color: const Color(0xFFEF4444))]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 15, color: const Color(0xFFEF4444))]),
                    BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 8, color: const Color(0xFFEF4444))]),
                  ]
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text('Recent Transactions', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: transactionsAsyncValue.when(
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return const Center(child: Text('No transactions yet.', style: TextStyle(color: Colors.white54)));
                  }
                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final t = transactions[index];
                      final isIncome = t.type == 'income';
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isIncome ? const Color(0xFF10B981).withOpacity(0.2) : const Color(0xFFEF4444).withOpacity(0.2),
                          child: Icon(
                            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                            color: isIncome ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          ),
                        ),
                        title: Text(t.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: Text(t.date.toString().substring(0, 10), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                        trailing: Text(
                          '${isIncome ? '+' : '-'} Rp ${t.amount.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: isIncome ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF10B981))),
                error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF10B981),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Open Add Transaction
        },
      ),
    );
  }
}
