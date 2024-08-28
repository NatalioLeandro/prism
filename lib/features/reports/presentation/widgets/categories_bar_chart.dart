/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:fl_chart/fl_chart.dart';

/* Project Imports */
import 'package:prism/core/enums/expense_category.dart';

class BarChartCategories extends StatefulWidget {
  final Map<ExpenseCategory, double> categoryData;
  final Map<String, Color> colors;
  final Map<String, ExpenseCategory> categories;

  const BarChartCategories({
    super.key,
    required this.categoryData,
    required this.colors,
    required this.categories,
  });

  @override
  State<BarChartCategories> createState() => _BarChartCategoriesState();
}

class _BarChartCategoriesState extends State<BarChartCategories> {
  @override
  Widget build(BuildContext context) {
    final categories = widget.categoryData.keys.toList();
    final values = widget.categoryData.values.toList();
    final maxValue = values.fold(
        0.0,
        (previousValue, element) =>
            previousValue > element ? previousValue : element);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Distribuição de Despesas por Categoria',
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
                    barGroups: List.generate(
                      categories.length,
                      (index) => BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: values[index],
                            color: widget.colors.entries
                                .firstWhere(
                                  (entry) =>
                                      widget.categories[entry.key] ==
                                      categories[index],
                                  orElse: () => const MapEntry('', Colors.black),
                                )
                                .value,
                            width: 20,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ],
                      ),
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < categories.length) {
                              final category = widget.categories.keys.firstWhere(
                                (key) =>
                                    widget.categories[key] == categories[index],
                                orElse: () => '',
                              );
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  category.length > 6
                                      ? '${category.substring(0, 6)}...'
                                      : category,
                                  style: const TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            }
                            return const Text('');
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
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                value.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 10,
                                ),
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
