/* Project Imports */
import 'package:prism/features/finance/domain/entities/expense.dart';
import 'package:prism/core/enums/expense_category.dart';

class ExpenseModel extends ExpenseEntity {
  ExpenseModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.date,
    required super.category,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      title: json['title'],
      amount: (json['amount'] ?? 0.0).toDouble(),
      date: DateTime.parse(json['date']),
      category: ExpenseCategory.values.firstWhere(
        (e) => e.toString() == json['category'],
        orElse: () => ExpenseCategory.others,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category.toString(),
    };
  }

  ExpenseModel copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    ExpenseCategory? category,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }
}
