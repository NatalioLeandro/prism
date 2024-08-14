/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/auth/domain/repositories/auth_repository.dart';
import 'package:prism/core/errors/failures.dart';
import 'package:prism/core/usecase/usecase.dart';

class UpdateUserBalance implements UseCase<void, UpdateUserBalanceParams> {
  final AuthRepository _authRepository;

  UpdateUserBalance(this._authRepository);

  @override
  Future<Either<Failure, void>> call(UpdateUserBalanceParams params) async {
    return _authRepository.updateUserBalance(
      userId: params.userId,
      newBalance: params.newBalance,
    );
  }
}

class UpdateUserBalanceParams {
  final String userId;
  final double newBalance;

  UpdateUserBalanceParams({
    required this.userId,
    required this.newBalance,
  });
}
