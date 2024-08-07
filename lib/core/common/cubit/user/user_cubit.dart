/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/features/account/domain/entities/account.dart';
import 'package:prism/core/common/entities/user.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitialState());

  void update(UserEntity? user) {
    if (user != null) {
      emit(UserLoggedInState(
        user,
      ));
    } else {
      emit(UserInitialState());
    }
  }

  void updateAccount(AccountEntity? account) {
    if (account != null) {
      emit(UserAccountLoadedState(
        account,
      ));
    } else {
      emit(UserAccountLoadingState());
    }
  }

  void updateAppTheme(bool isDark) {
    emit(UserAppThemeState(isDark));
  }

}
