/* Package Imports */
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

/* Core Imports */
import 'package:prism/core/common/cubit/user/user_cubit.dart';
import 'package:prism/core/network/connection_checker.dart';
import 'core/common/cubit/theme/theme_cubit.dart';

/* Auth Feature Imports */
import 'package:prism/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:prism/features/auth/domain/usecases/user_password_recover.dart';
import 'package:prism/features/auth/domain/repositories/auth_repository.dart';
import 'package:prism/features/auth/domain/usecases/user_register.dart';
import 'package:prism/features/auth/domain/usecases/current_user.dart';
import 'package:prism/features/auth/domain/usecases/user_logout.dart';
import 'package:prism/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:prism/features/auth/domain/usecases/user_login.dart';
import 'package:prism/features/auth/data/datasources/remote.dart';


/* Transaction Feature Imports */
// import 'package:prism/features/finance/data/repositories/finance_repository_impl.dart';
// import 'package:prism/features/finance/domain/repositories/finance_repository.dart';
// import 'package:prism/features/finance/domain/usecases/create_finance.dart';
// import 'package:prism/features/finance/presentation/bloc/finance_bloc.dart';
// import 'package:prism/features/finance/domain/usecases/delete_finance.dart';
// import 'package:prism/features/finance/domain/usecases/update_finance.dart';
// import 'package:prism/features/finance/domain/usecases/get_finances.dart';
// import 'package:prism/features/finance/domain/usecases/get_finance.dart';
// import 'package:prism/features/finance/data/datasources/remote.dart';
// import 'package:prism/features/finance/data/datasources/local.dart';

part 'dependencies.main.dart';