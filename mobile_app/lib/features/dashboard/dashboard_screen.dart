import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:shimmer/shimmer.dart';
import '../services/providers.dart';
import '../services/security_service.dart';
import '../../core/utils/currency_formatter.dart';
import '../add_transaction/add_transaction_sheet.dart';
import '../settings/settings_screen.dart';
import '../analytics/analytics_screen.dart';
import '../../core/helpers/empty_state_widget.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final balance = ref.watch(balanceProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate monthly totals
    double monthlyIncome = 0;
    double monthlyExpense = 0;
    transactionsAsync.whenData((txs) {
      final now = DateTime.now();
      for (var t in txs) {
        if (t.date.month == now.month && t.date.year == now.year) {
          if (t.type == 'income') {
            monthlyIncome += t.amount;
          } else {
            monthlyExpense += t.amount;
          }
        }
      }
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                children: [
                   // Gradient Background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF10B981),
                          const Color(0xFF10B981).withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  
                  // Blurry Glass Overlayer
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                  ),
                  
                  // Balance Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 48),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Available Balance',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                ref.read(privacyModeProvider.notifier).state = !ref.read(privacyModeProvider);
                              },
                              child: Icon(
                                ref.watch(privacyModeProvider) ? Icons.visibility_off : Icons.visibility,
                                color: Colors.white.withOpacity(0.8),
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          ref.watch(privacyModeProvider) 
                            ? '••••••••' 
                            : CurrencyFormatter.format(balance, ref.watch(currencyProvider)),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ).animate().fadeIn(duration: 800.ms).scale(delay: 200.ms),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.analytics_outlined, color: Colors.white),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const AnalyticsScreen())),
              ),
              IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
                onPressed: () => AdaptiveTheme.of(context).toggleThemeMode(),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SettingsScreen())),
              ),
            ],
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Smart Insights Banner
                  Consumer(
                    builder: (context, ref, child) {
                      final insight = ref.watch(smartInsightsProvider);
                      if (insight == null) return const SizedBox();
                      return Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF10B981).withOpacity(0.1),
                              const Color(0xFF3B82F6).withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF10B981).withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.auto_awesome, color: Color(0xFF10B981), size: 18),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                insight,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn().slideX(begin: -0.1);
                    },
                  ),

                  _buildSectionTitle('Active Spending'),
                  const SizedBox(height: 16),
                  _buildSpendingChart(ref).animate().fadeIn(delay: 200.ms).scale(curve: Curves.backOut),
                  const SizedBox(height: 24),

                  // Monthly Summary Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          'Monthly Income',
                          ref.watch(privacyModeProvider) ? '••••' : CurrencyFormatter.format(monthlyIncome, ref.watch(currencyProvider)),
                          const Color(0xFF10B981),
                          Icons.arrow_upward,
                        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          'Monthly Expense',
                          ref.watch(privacyModeProvider) ? '••••' : CurrencyFormatter.format(monthlyExpense, ref.watch(currencyProvider)),
                          Colors.redAccent,
                          Icons.arrow_downward,
                        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Search & Filter Row
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search transactions...',
                        border: InputBorder.none,
                        icon: Icon(Icons.search, size: 20, color: Colors.grey),
                      ),
                      onChanged: (v) {
                        ref.read(transactionsProvider.notifier).setSearchQuery(v);
                      },
                    ),
                  ).animate().fadeIn(delay: 600.ms).scale(),
                  
                  const SizedBox(height: 16),
                  
                  // Type Filter
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(ref, null, 'All'),
                        const SizedBox(width: 8),
                        _buildFilterChip(ref, 'income', 'Income'),
                        const SizedBox(width: 8),
                        _buildFilterChip(ref, 'expense', 'Expense'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Category Filter
                  ref.watch(categoriesProvider).when(
                    data: (categories) => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildCategoryChip(ref, null, 'All Categories'),
                          ...categories.map((c) => Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: _buildCategoryChip(ref, c.id, '${c.icon} ${c.name}'),
                              )),
                        ],
                      ),
                    ),
                    loading: () => const SizedBox(height: 32),
                    error: (_, __) => const SizedBox(),
                  ),
                  
                  const SizedBox(height: 16),
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
                  hasScrollBody: false,
                  child: EmptyStateWidget(
                    title: 'No Transactions',
                    message: 'Your financial journey starts with a single tap. Add your first log below!',
                    lottieUrl: 'https://assets9.lottiefiles.com/packages/lf20_m69yidvw.json',
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
                      subtitle: Text(DateFormat.yMMMd().format(t.date), style: const TextStyle(fontSize: 12)),
                      trailing: Text(
                        ref.watch(privacyModeProvider) ? '••••' : '${t.type == 'income' ? '+' : '-'} ${CurrencyFormatter.format(t.amount, ref.watch(currencyProvider))}',
                        style: TextStyle(
                          color: t.type == 'income' ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1);
                  },
                  childCount: transactions.length,
                ),
              );
            },
            loading: () => SliverFillRemaining(
              child: Shimmer.fromColors(
                baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 40, height: 40, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                        const SizedBox(width: 16),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(width: double.infinity, height: 16, color: Colors.white),
                          const SizedBox(height: 8),
                          Container(width: 100, height: 12, color: Colors.white),
                        ])),
                        const SizedBox(width: 16),
                        Container(width: 80, height: 16, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            error: (e, st) => SliverFillRemaining(
              child: Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: FloatingActionButton.extended(
          backgroundColor: const Color(0xFF10B981),
          foregroundColor: Colors.white,
          elevation: 8,
          highlightElevation: 12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          onPressed: () {
            HapticFeedback.lightImpact();
            _showAddTransaction(context);
          },
          label: const Text('New Transaction', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5)),
          icon: const Icon(Icons.add_rounded, weight: 700),
        ).animate().slideY(begin: 1.0, duration: 600.ms, curve: Curves.easeOutCirc).fadeIn(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color.withOpacity(0.8),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(WidgetRef ref, String? type, String label) {
    final currentFilter = ref.watch(transactionsProvider.notifier).filterType;
    final isActive = currentFilter == type;
    
    return ChoiceChip(
      label: Text(label),
      selected: isActive,
      onSelected: (selected) {
        if (selected) {
          HapticFeedback.selectionClick();
          ref.read(transactionsProvider.notifier).setFilterType(type);
        }
      },
      selectedColor: const Color(0xFF10B981).withOpacity(0.2),
      checkmarkColor: const Color(0xFF10B981),
      labelStyle: TextStyle(
        color: isActive ? const Color(0xFF10B981) : Colors.grey,
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildCategoryChip(WidgetRef ref, int? categoryId, String label) {
    final currentFilter = ref.watch(transactionsProvider.notifier).filterCategoryId;
    final isActive = currentFilter == categoryId;
    
    return ChoiceChip(
      label: Text(label),
      selected: isActive,
      onSelected: (selected) {
        if (selected) {
          HapticFeedback.selectionClick();
          ref.read(transactionsProvider.notifier).setFilterCategory(categoryId);
        }
      },
      selectedColor: const Color(0xFF10B981).withOpacity(0.2),
      checkmarkColor: const Color(0xFF10B981),
      labelStyle: TextStyle(
        color: isActive ? const Color(0xFF10B981) : Colors.grey,
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
      ),
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
