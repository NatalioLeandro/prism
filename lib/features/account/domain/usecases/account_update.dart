/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/account/domain/repositories/account_repository.dart';
import 'package:prism/features/account/domain/entities/account.dart';
import 'package:prism/core/enums/account_type.dart';
import 'package:prism/core/errors/failures.dart';
import 'package:prism/core/usecase/usecase.dart';

class AccountUpdate implements UseCase<AccountEntity, AccountUpdateParams> {
  final AccountRepository _accountRepository;

  AccountUpdate(this._accountRepository);

  @override
  Future<Either<Failure, AccountEntity>> call(
      AccountUpdateParams params) async {
    return await _accountRepository.updateAccount(
      id: params.id,
      balance: params.balance,
      type: params.type,
    );
  }
}

class AccountUpdateParams {
  final String id;
  final double balance;
  final AccountType type;

  AccountUpdateParams({
    required this.id,
    required this.balance,
    required this.type,
  });
}
