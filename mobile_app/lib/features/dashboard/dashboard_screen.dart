import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import '../../services/providers.dart';
import '../add_transaction/add_transaction_sheet.dart';
import '../settings/settings_screen.dart';
import '../analytics/analytics_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(balanceProvider);
    final transactionsAsync = ref.watch(transactionsProvider);
    final isDark = AdaptiveTheme.of(context).mode.isDark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF10B981),
                      const Color(0xFF10B981).withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 48),
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rp ${balance.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () => AdaptiveTheme.of(context).toggleThemeMode(),
              ),
            ],
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Active Spending'),
                  const SizedBox(height: 16),
                  _buildSpendingChart(ref),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Recent Transactions'),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          
          transactionsAsync.when(
            data: (transactions) {
              if (transactions.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text('No transactions yet.', style: TextStyle(color: Colors.grey)),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final t = transactions[index];
                    final isIncome = t.type == 'income';
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (isIncome ? Colors.green : Colors.red).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isIncome ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                          color: isIncome ? Colors.green : Colors.red,
                        ),
                      ),
                      title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(t.date.toString().substring(0, 10)),
                      trailing: Text(
                        '${isIncome ? '+' : '-'} Rp ${t.amount.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: isIncome ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1);
                  },
                  childCount: transactions.length,
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, st) => SliverFillRemaining(
              child: Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF10B981),
        onPressed: () => _showAddTransaction(context),
        label: const Text('Add Transaction', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add, color: Colors.white),
      ).animate().scale(delay: 500.ms),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSpendingChart(WidgetRef ref) {
    final spendingData = ref.watch(monthlySpendingProvider);
    
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: spendingData.isEmpty 
        ? const Center(child: Text('Add an expense to see trends', style: TextStyle(fontSize: 12, color: Colors.grey)))
        : BarChart(
            BarChartData(
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(value.toInt().toString(), style: const TextStyle(fontSize: 10, color: Colors.grey));
                    },
                  ),
                ),
              ),
              barGroups: spendingData.entries.map((e) {
                return BarChartGroupData(
                  x: int.parse(e.key),
                  barRods: [
                    BarChartRodData(
                      toY: e.value,
                      color: const Color(0xFF10B981),
                      width: 14,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
    );
  }

  void _showAddTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTransactionSheet(),
    );
  }
}
