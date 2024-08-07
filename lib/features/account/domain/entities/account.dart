/* Project Imports */
import 'package:prism/core/enums/account_type.dart';

class AccountEntity {
  final String id;
  final double balance;
  final AccountType type;

  AccountEntity({
    required this.id,
    required this.balance,
    required this.type,
  });
}
