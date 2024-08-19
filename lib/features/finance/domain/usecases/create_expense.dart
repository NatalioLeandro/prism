/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/finance/domain/repositories/expense_repository.dart';
import 'package:prism/features/finance/domain/entities/expense.dart';
import 'package:prism/core/enums/expense_category.dart';
import 'package:prism/core/errors/failures.dart';
import 'package:prism/core/usecase/usecase.dart';

class CreateExpense implements UseCase<ExpenseEntity, CreateExpenseParams> {
  final ExpenseRepository _expenseRepository;

  CreateExpense(this._expenseRepository);

  @override
  Future<Either<Failure, ExpenseEntity>> call(CreateExpenseParams params) async {
    return await _expenseRepository.createExpense(
      userId: params.userId,
      title: params.title,
      amount: params.amount,
      date: params.date,
      category: params.category,
    );
  }
}

class CreateExpenseParams {
  final String userId;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;

  CreateExpenseParams({
    required this.userId,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });
}
