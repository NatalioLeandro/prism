/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/auth/domain/repositories/auth_repository.dart';
import 'package:prism/core/common/entities/user.dart';
import 'package:prism/core/errors/failures.dart';
import 'package:prism/core/usecase/usecase.dart';

class UserRegister implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository _authRepository;

  UserRegister(this._authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    return await _authRepository.register(
      name: params.name,
      email: params.email,
      photo: params.photo,
      password: params.password,
    );
  }
}

class RegisterParams {
  final String name;
  final String email;
  final String photo;
  final String password;

  RegisterParams({
    required this.name,
    required this.email,
    required this.photo,
    required this.password,
  });
}
