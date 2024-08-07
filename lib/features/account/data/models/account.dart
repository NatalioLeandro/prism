/* Project Imports */
import 'package:prism/features/account/domain/entities/account.dart';
import 'package:prism/core/enums/account_type.dart';

class AccountModel extends AccountEntity {
  AccountModel({
    required super.id,
    required super.balance,
    required super.type,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'],
      balance: json['balance'],
      type: AccountType.values[json['type']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'balance': balance,
      'type': type.index,
    };
  }

  AccountModel copyWith({
    String? id,
    double? balance,
    AccountType? type,
  }) {
    return AccountModel(
      id: id ?? this.id,
      balance: balance ?? this.balance,
      type: type ?? this.type,
    );
  }
}
