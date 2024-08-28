/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:fl_chart/fl_chart.dart';

/* Project Imports */
import 'package:prism/core/constants/constants.dart';

class BarChartExpensesOverTime extends StatelessWidget {
  final Map<String, double> monthlyExpenses;

  const BarChartExpensesOverTime({super.key, required this.monthlyExpenses});

  @override
  Widget build(BuildContext context) {
    final sortedMonths = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez'
    ];

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final sortedExpenses = {
      for (final month in sortedMonths)
        month: monthlyExpenses[months[sortedMonths.indexOf(month)]] ?? 0.0
    };

    final maxY = sortedExpenses.values
        .fold(0.0, (max, value) => value > max ? value : max);
    final interval = maxY > 0 ? maxY / 5 : 1;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Despesas Mensais',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    alignment: BarChartAlignment.spaceBetween,
                    maxY: maxY > 0 ? maxY : 1,
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < sortedMonths.length) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(sortedMonths[index],
                                    style: const TextStyle(fontSize: 10)),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 35,
                          interval: interval.toDouble(),
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
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
                    barGroups: sortedExpenses.entries.map((entry) {
                      final index = sortedMonths.indexOf(entry.key);
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value,
                            color: Constants().monthColors[entry.key] ??
                                Colors.grey,
                            width: 20,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ],
                      );
                    }).toList(),
                    gridData: const FlGridData(show: true),
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
