/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/auth/domain/repositories/auth_repository.dart';
import 'package:prism/core/errors/failures.dart';
import 'package:prism/core/usecase/usecase.dart';

class UpdateUserFixedIncome implements UseCase<void, UpdateUserFixedIncomeParams> {
  final AuthRepository _authRepository;

  UpdateUserFixedIncome(this._authRepository);

  @override
  Future<Either<Failure, void>> call(UpdateUserFixedIncomeParams params) async {
    return _authRepository.updateUserFixedIncome(
      userId: params.userId,
      newFixedIncome: params.newFixedIncome,
    );
  }
}

class UpdateUserFixedIncomeParams {
  final String userId;
  final double newFixedIncome;

  UpdateUserFixedIncomeParams({
    required this.userId,
    required this.newFixedIncome,
  });
}
