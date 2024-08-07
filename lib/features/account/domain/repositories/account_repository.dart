/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/account/domain/entities/account.dart';
import 'package:prism/core/enums/account_type.dart';
import 'package:prism/core/errors/failures.dart';

abstract interface class AccountRepository {
  Future<Either<Failure, AccountEntity>> register({
    required String id,
    required double balance,
    required AccountType type,
  });

  Future<Either<Failure, AccountEntity>> getAccount();

  Future<Either<Failure, AccountEntity>> updateAccount({
    required String id,
    required double balance,
    required AccountType type,
  });
}
