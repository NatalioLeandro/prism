/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:intl/intl.dart';

/* Project Imports */
import 'package:prism/features/finance/domain/entities/expense.dart';
import 'package:prism/core/constants/constants.dart';
import 'package:prism/core/utils/show_dialog.dart';
import 'package:prism/core/enums/alert_type.dart';

class FinanceCard extends StatelessWidget {
  final ExpenseEntity expense;
  final Map<String, String> groupMap;
  final VoidCallback onDelete;

  const FinanceCard({
    super.key,
    required this.expense,
    required this.groupMap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final groupName =
        expense.groupId != null && groupMap.containsKey(expense.groupId!)
            ? groupMap[expense.groupId!]
            : null;
    final formattedDate = DateFormat('dd/MM/yy').format(expense.date.toLocal());

    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 6,
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Container(
                    margin: const EdgeInsets.only(left: 7.0, right: 7.0),
                    child: Text(
                      expense.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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
                  title: Column(
                    children: [
                      if (groupName != null &&
                          expense.groupId != "0" &&
                          expense.groupId!.isNotEmpty)
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(bottom: 5.0),
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            'Grupo: $groupName',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      Container(
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
                              .firstWhere((element) =>
                                  element.value == expense.category)
                              .key,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    'Data: $formattedDate',
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                showMessageDialog(
                  context,
                  title: 'Excluir Finança',
                  message: 'Você tem certeza que deseja excluir esta finança?',
                  type: AlertType.warning,
                  onConfirm: onDelete,
                  onDismiss: () {},
                );
              },
            ),
          ),
          if (expense.type.name == 'fixed')
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: const Icon(
                  Icons.push_pin,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
