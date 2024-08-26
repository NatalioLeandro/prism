part of 'user_cubit.dart';

@immutable
sealed class UserState {
  get id => null;
  double get balance => 0;
  AccountType get account => AccountType.free;
}

class UserInitialState extends UserState {}

class UserLoggedInState extends UserState {
  final UserEntity user;

  UserLoggedInState(this.user);

  @override
  String get id => user.id;

  @override
  double get balance => user.fixedIncome;

  @override
  AccountType get account => user.account;
}
