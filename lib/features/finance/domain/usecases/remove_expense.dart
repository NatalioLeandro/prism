import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/finance/domain/repositories/expense_repository.dart';
import 'package:prism/core/errors/failures.dart';
import 'package:prism/core/usecase/usecase.dart';

class RemoveExpense implements UseCase<void, RemoveExpenseParams> {
  final ExpenseRepository _expenseRepository;

  RemoveExpense(this._expenseRepository);

  @override
  Future<Either<Failure, void>> call(RemoveExpenseParams params) async {
    return await _expenseRepository.removeExpense(
      userId: params.userId,
      id: params.id,
    );
  }
}

class RemoveExpenseParams {
  final String userId;
  final String id;

  RemoveExpenseParams({
    required this.userId,
    required this.id,
  });
}
