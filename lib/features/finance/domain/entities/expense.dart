/* Project Imports */
import 'package:prism/core/enums/expense_category.dart';

class ExpenseEntity {
  final String id;
  final String title;
  final double amount;
  final String? groupId;
  final DateTime date;
  final ExpenseCategory category;

  ExpenseEntity({
    required this.id,
    required this.title,
    required this.amount,
    this.groupId,
    required this.date,
    required this.category,
  });
}
