/* Package Imports */
import 'package:firebase_auth/firebase_auth.dart';

/* Project Imports */
import 'package:prism/core/common/entities/user.dart';
import 'package:prism/core/enums/account_type.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.photo,
    required super.fixedIncome,
    required super.account,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      photo: json['photo'],
      fixedIncome: (json['fixedIncome'] ?? 0.0).toDouble(),
      account: AccountType.values.firstWhere(
            (e) => e.toString() == json['account'],
        orElse: () => AccountType.free,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photo': photo,
      'balance': fixedIncome,
      'account': account.toString(),
    };
  }

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      photo: user.photoURL ?? '',
      fixedIncome: 0,
      account: AccountType.free,
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? photo,
    double? fixedIncome,
    AccountType? account,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      fixedIncome: fixedIncome ?? this.fixedIncome,
      account: account ?? this.account,
    );
  }

  static fromEntity(UserEntity user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      photo: user.photo,
      fixedIncome: user.fixedIncome,
      account: user.account,
    );
  }
}
