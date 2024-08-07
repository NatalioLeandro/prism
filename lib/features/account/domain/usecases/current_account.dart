/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/account/domain/repositories/account_repository.dart';
import 'package:prism/features/account/domain/entities/account.dart';
import 'package:prism/core/errors/failures.dart';
import 'package:prism/core/usecase/usecase.dart';

class CurrentAccount implements UseCase<void, NoParams> {
  final AccountRepository _accountRepository;

  CurrentAccount(this._accountRepository);

  @override
  Future<Either<Failure, AccountEntity>> call(NoParams params) async {
    return await _accountRepository.getAccount();
  }
}
