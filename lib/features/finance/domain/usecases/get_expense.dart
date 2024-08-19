/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/finance/domain/repositories/expense_repository.dart';
import 'package:prism/features/finance/domain/entities/expense.dart';
import 'package:prism/core/errors/failures.dart';
import 'package:prism/core/usecase/usecase.dart';

class GetExpense implements UseCase<ExpenseEntity, GetExpenseParams> {
  final ExpenseRepository _expenseRepository;

  GetExpense(this._expenseRepository);

  @override
  Future<Either<Failure, ExpenseEntity>> call(GetExpenseParams params) async {
    return await _expenseRepository.getExpense(
      userId: params.userId,
      id: params.id,
    );
  }
}

class GetExpenseParams {
  final String userId;
  final String id;

  GetExpenseParams({
    required this.userId,
    required this.id,
  });
}
