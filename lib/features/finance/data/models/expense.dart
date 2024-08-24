/* Project Imports */
import 'package:prism/features/finance/domain/entities/expense.dart';
import 'package:prism/core/enums/expense_category.dart';
import 'package:prism/core/enums/expense_type.dart';

class ExpenseModel extends ExpenseEntity {
  ExpenseModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.groupId,
    required super.date,
    required super.category,
    required super.type,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      title: json['title'],
      amount: (json['amount'] ?? 0.0).toDouble(),
      groupId: json['groupId'] ?? '',
      date: DateTime.parse(json['date']),
      category: ExpenseCategory.values.firstWhere(
        (e) => e.toString() == json['category'],
        orElse: () => ExpenseCategory.others,
      ),
      type: ExpenseType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => ExpenseType.variable,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'groupId': groupId,
      'date': date.toIso8601String(),
      'category': category.toString(),
      'type': type.toString(),
    };
  }

  ExpenseModel copyWith({
    String? id,
    String? title,
    double? amount,
    String? groupId,
    DateTime? date,
    ExpenseCategory? category,
    ExpenseType? type,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      groupId: groupId ?? this.groupId,
      date: date ?? this.date,
      category: category ?? this.category,
      type: type ?? this.type,
    );
  }
}
