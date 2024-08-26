/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/core/common/entities/user.dart';
import 'package:prism/core/enums/account_type.dart';

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
}
