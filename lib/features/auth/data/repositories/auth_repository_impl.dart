/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/auth/domain/repositories/auth_repository.dart';
import 'package:prism/features/auth/data/datasources/remote.dart';
import 'package:prism/core/network/connection_checker.dart';
import 'package:prism/core/common/entities/user.dart';
import 'package:prism/core/constants/constants.dart';
import 'package:prism/core/enums/account_type.dart';
import 'package:prism/core/errors/exceptions.dart';
import 'package:prism/core/errors/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final ConnectionChecker _connectionChecker;

  const AuthRepositoryImpl(
    this._authRemoteDataSource,
    this._connectionChecker,
  );

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      if (!await _connectionChecker.connected) {
        final user = await _authRemoteDataSource.getCurrentUserData();
        if (user == null) {
          return left(Failure(Constants.connectionError));
        }
        return right(user);
      }
      final user = await _authRemoteDataSource.getCurrentUserData();

      if (user == null) {
        return left(Failure('Usuário não logado'));
      }

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    return _getUserEntity(
      () async => await _authRemoteDataSource.login(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String name,
    required String photo,
    required String password,
  }) async {
    return _getUserEntity(
      () async => await _authRemoteDataSource.register(
        email: email,
        name: name,
        photo: photo,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      if (!await _connectionChecker.connected) {
        return left(Failure(Constants.connectionError));
      }
      await _authRemoteDataSource.logout();

      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> recover({required String email}) async {
    try {
      if (!await _connectionChecker.connected) {
        return left(Failure(Constants.connectionError));
      }
      await _authRemoteDataSource.recover(email: email);

      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserFixedIncome({
    required String userId,
    required double newFixedIncome,
  }) async {
    return _getUserEntity(
      () async => await _authRemoteDataSource.updateUserFixedIncome(
        userId,
        newFixedIncome,
      ),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserAccountType({
    required String userId,
    required AccountType newAccountType,
  }) async {
    return _getUserEntity(
      () async => await _authRemoteDataSource.updateUserAccountType(
        userId,
        newAccountType,
      ),
    );
  }

  Future<Either<Failure, UserEntity>> _getUserEntity(
      Future<UserEntity> Function() getUser,
      ) async {
    try {
      if (!await _connectionChecker.connected) {
        return left(Failure(Constants.connectionError));
      }

      final user = await getUser();

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
