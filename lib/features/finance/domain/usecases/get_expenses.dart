import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/finance/domain/repositories/expense_repository.dart';
import 'package:prism/features/finance/domain/entities/expense.dart';
import 'package:prism/core/errors/failures.dart';
import 'package:prism/core/usecase/usecase.dart';

class GetExpenses implements UseCase<List<ExpenseEntity>, GetExpensesParams> {
  final ExpenseRepository _expenseRepository;

  GetExpenses(this._expenseRepository);

  @override
  Future<Either<Failure, List<ExpenseEntity>>> call(GetExpensesParams params) async {
    return await _expenseRepository.getExpenses(
      userId: params.userId,
    );
  }
}

class GetExpensesParams {
  final String userId;

  GetExpensesParams({
    required this.userId,
  });
}
