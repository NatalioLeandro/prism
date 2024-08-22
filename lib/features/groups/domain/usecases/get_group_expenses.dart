/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/groups/domain/repositories/groups_repository.dart';
import 'package:prism/features/finance/domain/entities/expense.dart';
import 'package:prism/core/errors/failures.dart';
import 'package:prism/core/usecase/usecase.dart';

class GetGroupExpenses
    implements UseCase<List<ExpenseEntity>, GetGroupExpensesParams> {
  final GroupRepository _groupRepository;

  GetGroupExpenses(this._groupRepository);

  @override
  Future<Either<Failure, List<ExpenseEntity>>> call(
      GetGroupExpensesParams params) async {
    return await _groupRepository.getGroupExpenses(
      owner: params.owner,
      id: params.id,
    );
  }
}

class GetGroupExpensesParams {
  final String owner;
  final String id;

  GetGroupExpensesParams({
    required this.owner,
    required this.id,
  });
}
