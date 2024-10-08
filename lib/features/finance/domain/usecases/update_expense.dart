import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/finance/domain/repositories/expense_repository.dart';
import 'package:prism/features/finance/domain/entities/expense.dart';
import 'package:prism/core/enums/expense_category.dart';
import 'package:prism/core/enums/expense_type.dart';
import 'package:prism/core/errors/failures.dart';
import 'package:prism/core/usecase/usecase.dart';

class UpdateExpense implements UseCase<ExpenseEntity, UpdateExpenseParams> {
  final ExpenseRepository _expenseRepository;

  UpdateExpense(this._expenseRepository);

  @override
  Future<Either<Failure, ExpenseEntity>> call(UpdateExpenseParams params) async {
    return await _expenseRepository.updateExpense(
      userId: params.userId,
      id: params.id,
      title: params.title,
      amount: params.amount,
      groupId: params.groupId,
      date: params.date,
      category: params.category,
      type: params.type,
    );
  }
}

class UpdateExpenseParams {
  final String userId;
  final String id;
  final String title;
  final double amount;
  final String groupId;
  final DateTime date;
  final ExpenseCategory category;
  final ExpenseType type;

  UpdateExpenseParams({
    required this.userId,
    required this.id,
    required this.title,
    required this.amount,
    required this.groupId,
    required this.date,
    required this.category,
    required this.type,
  });
}