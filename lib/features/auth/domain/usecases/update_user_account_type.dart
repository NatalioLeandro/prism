/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/auth/domain/repositories/auth_repository.dart';
import 'package:prism/core/common/entities/user.dart';
import 'package:prism/core/enums/account_type.dart';
import 'package:prism/core/errors/failures.dart';
import 'package:prism/core/usecase/usecase.dart';

class UpdateUserAccountType
    implements UseCase<void, UpdateUserAccountTypeParams> {
  final AuthRepository _authRepository;

  UpdateUserAccountType(this._authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateUserAccountTypeParams params) async {
    return _authRepository.updateUserAccountType(
      userId: params.userId,
      newAccountType: params.newAccountType,
    );
  }
}

class UpdateUserAccountTypeParams {
  final String userId;
  final AccountType newAccountType;

  UpdateUserAccountTypeParams({
    required this.userId,
    required this.newAccountType,
  });
}
