/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/core/common/entities/user.dart';
import 'package:prism/core/errors/failures.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String name,
    required String photo,
    required String password,
  });

  Future<Either<Failure, void>> recover({
    required String email,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity>> getCurrentUser();
}
