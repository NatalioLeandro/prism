/* Flutter Imports */
import 'package:flutter/material.dart';

/* Project Imports */
import 'package:prism/features/finance/domain/entities/expense.dart';
import 'package:prism/core/constants/constants.dart';

class FinanceCard extends StatelessWidget {
  final ExpenseEntity expense;

  const FinanceCard({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 6,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                expense.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(
                  'R\$ ${expense.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            const Divider(
              height: 0,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(10.0),
              title: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 5.0),
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: Constants()
                      .categoryColorMap
                      .entries
                      .firstWhere(
                        (element) =>
                            element.key ==
                            Constants()
                                .categoryMap
                                .entries
                                .firstWhere((element) =>
                                    element.value == expense.category)
                                .key,
                      )
                      .value,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  Constants()
                      .categoryMap
                      .entries
                      .firstWhere(
                          (element) => element.value == expense.category)
                      .key,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              subtitle: Text(
                'Criada em: ${expense.date.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
