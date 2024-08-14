/* Project Imports */
import 'package:prism/core/enums/account_type.dart';

class UserEntity {
  final String id;
  final String email;
  final String name;
  final String photo;
  final double balance;
  final AccountType account;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.photo,
    required this.balance,
    required this.account,
  });
}
