/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/account/domain/repositories/account_repository.dart';
import 'package:prism/features/account/domain/entities/account.dart';
import 'package:prism/core/enums/account_type.dart';
import 'package:prism/core/errors/failures.dart';
import 'package:prism/core/usecase/usecase.dart';

class AccountRegister implements UseCase<AccountEntity, AccountRegisterParams> {
  final AccountRepository _accountRepository;

  AccountRegister(this._accountRepository);

  @override
  Future<Either<Failure, AccountEntity>> call(
      AccountRegisterParams params) async {
    return await _accountRepository.register(
      id: params.id,
      balance: params.balance,
      type: params.type,
    );
  }
}

class AccountRegisterParams {
  final String id;
  final double balance;
  final AccountType type;

  AccountRegisterParams({
    required this.id,
    required this.balance,
    required this.type,
  });
}
