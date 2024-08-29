/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:fl_chart/fl_chart.dart';

/* Project Imports */
import 'package:prism/core/enums/expense_category.dart';

class FixedIncomeVsExpensesChart extends StatelessWidget {
  final Map<ExpenseCategory, double> categoryData;
  final double fixedIncome;
  final Color fixedIncomeColor;
  final Color expensesColor;

  const FixedIncomeVsExpensesChart({
    super.key,
    required this.categoryData,
    required this.fixedIncome,
    this.fixedIncomeColor = Colors.green,
    this.expensesColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    final totalExpenses =
        categoryData.values.fold(0.0, (sum, item) => sum + item);

    final maxValue = fixedIncome > totalExpenses ? fixedIncome : totalExpenses;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Compare seus gastos',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              height: 20,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 300,
                child: BarChart(
                  BarChartData(
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: fixedIncome,
                            color: fixedIncomeColor,
                            width: 20,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: totalExpenses,
                            color: expensesColor,
                            width: 20,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ],
                      ),
                    ],
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 0:
                                return const Text('Renda Fixa');
                              case 1:
                                return const Text('Despesas');
                              default:
                                return const Text('');
                            }
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: maxValue / 5,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                value.toStringAsFixed(0),
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.onPrimary,
                          width: 1,
                        ),
                        left: BorderSide(
                          color: Theme.of(context).colorScheme.onPrimary,
                          width: 1,
                        ),
                      ),
                    ),
                    gridData: const FlGridData(show: true),
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxValue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
