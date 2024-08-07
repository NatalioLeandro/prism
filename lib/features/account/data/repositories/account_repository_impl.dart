/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/account/domain/repositories/account_repository.dart';
import 'package:prism/features/account/domain/entities/account.dart';
import 'package:prism/features/account/data/datasources/remote.dart';
import 'package:prism/core/network/connection_checker.dart';
import 'package:prism/core/constants/constants.dart';
import 'package:prism/core/enums/account_type.dart';
import 'package:prism/core/errors/exceptions.dart';
import 'package:prism/core/errors/failures.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource _accountRemoteDataSource;
  final ConnectionChecker _connectionChecker;

  const AccountRepositoryImpl(
    this._accountRemoteDataSource,
    this._connectionChecker,
  );

  @override
  Future<Either<Failure, AccountEntity>> register({
    required String id,
    required double balance,
    required AccountType type,
  }) async {
    return _getAccountEntity(
      () async => await _accountRemoteDataSource.createAccount(
        id: id,
        balance: balance,
        type: type,
      ),
    );
  }

  @override
  Future<Either<Failure, AccountEntity>> getAccount() async {
    try {
      if (!await _connectionChecker.connected) {
        final account = await _accountRemoteDataSource.getAccount();
        return right(account);
      }
      final account = await _accountRemoteDataSource.getAccount();

      return right(account);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, AccountEntity>> updateAccount({
    required String id,
    required double balance,
    required AccountType type,
  }) async {
    return _getAccountEntity(
      () async => await _accountRemoteDataSource.updateAccount(
        id: id,
        balance: balance,
        type: type,
      ),
    );
  }

  Future<Either<Failure, AccountEntity>> _getAccountEntity(
    Future<AccountEntity> Function() getAccount,
  ) async {
    try {
      if (!await _connectionChecker.connected) {
        return left(Failure(Constants.connectionError));
      }

      final account = await getAccount();
      return right(account);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
