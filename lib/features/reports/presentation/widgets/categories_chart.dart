/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:fl_chart/fl_chart.dart';

/* Project Imports */
import 'package:prism/core/enums/expense_category.dart';

class PieChartCategories extends StatefulWidget {
  final Map<ExpenseCategory, double> categoryData;
  final Map<String, Color> colors;
  final Map<String, ExpenseCategory> categories;

  const PieChartCategories({
    super.key,
    required this.categoryData,
    required this.colors,
    required this.categories,
  });

  @override
  State<PieChartCategories> createState() => _PieChartCategoriesState();
}

class _PieChartCategoriesState extends State<PieChartCategories> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    final totalValue =
        widget.categoryData.values.fold(0.0, (sum, item) => sum + item);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Despesas por Categoria',
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
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (pieTouchResponse != null &&
                                    pieTouchResponse.touchedSection != null) {
                                  touchedIndex = pieTouchResponse
                                      .touchedSection!.touchedSectionIndex;
                                } else {
                                  touchedIndex = null;
                                }
                              });
                            },
                          ),
                          sections: widget.categoryData.entries.map((entry) {
                            final index = widget.categoryData.keys
                                .toList()
                                .indexOf(entry.key);
                            final isTouched = index == touchedIndex;
                            final category = widget.categories.keys.firstWhere(
                              (key) => widget.categories[key] == entry.key,
                              orElse: () => '',
                            );
                            final percentage = (entry.value / totalValue) * 100;
                            final sectionColor = widget.colors.entries
                                .firstWhere(
                                  (color) => color.key == category,
                                  orElse: () => const MapEntry('', Colors.grey),
                                )
                                .value;

                            return PieChartSectionData(
                              title: isTouched
                                  ? ''
                                  : entry.value.toStringAsFixed(2),
                              value: entry.value,
                              color: sectionColor,
                              radius: isTouched ? 70 : 60,
                              badgeWidget: isTouched
                                  ? Container(
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        color: sectionColor,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Text(
                                        '$category\n${entry.value.toStringAsFixed(2)} (${percentage.toStringAsFixed(1)}%)',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : null,
                              badgePositionPercentageOffset: -1,
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                          sectionsSpace: 1,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.categoryData.entries.map((entry) {
                      final index =
                          widget.categoryData.keys.toList().indexOf(entry.key);
                      final category = widget.categories.keys.firstWhere(
                        (key) => widget.categories[key] == entry.key,
                        orElse: () => '',
                      );
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            touchedIndex = index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Container(
                                width: 15,
                                height: 15,
                                color: widget.colors[category] ?? Colors.grey,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                category,
                                style: TextStyle(
                                  color: touchedIndex == index
                                      ? widget.colors[category]
                                      : Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
