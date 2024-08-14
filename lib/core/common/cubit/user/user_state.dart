part of 'user_cubit.dart';

@immutable
sealed class UserState {
  get id => null;
  double get balance => 0;
}

class UserInitialState extends UserState {}

class UserLoggedInState extends UserState {
  final UserEntity user;

  UserLoggedInState(this.user);

  @override
  String get id => user.id;

  @override
  double get balance => user.balance;
}
