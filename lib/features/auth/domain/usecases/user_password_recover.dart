/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/auth/domain/repositories/auth_repository.dart';
import 'package:prism/core/errors/failures.dart';
import 'package:prism/core/usecase/usecase.dart';

class UserPasswordRecover implements UseCase<void, PasswordRecoverParams> {
  final AuthRepository _authRepository;

  UserPasswordRecover(this._authRepository);

  @override
  Future<Either<Failure, void>> call(PasswordRecoverParams params) async {
    return await _authRepository.recover(
      email: params.email,
    );
  }
}

class PasswordRecoverParams {
  final String email;

  PasswordRecoverParams({
    required this.email,
  });
}
