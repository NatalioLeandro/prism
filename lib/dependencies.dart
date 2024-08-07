/* Package Imports */
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

/* Core Imports */
import 'package:prism/core/common/cubit/user/user_cubit.dart';
import 'package:prism/core/network/connection_checker.dart';

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
// import 'package:prism/features/transaction/data/repositories/transaction_repository_impl.dart';
// import 'package:prism/features/transaction/domain/repositories/transaction_repository.dart';
// import 'package:prism/features/transaction/domain/usecases/create_transaction.dart';
// import 'package:prism/features/transaction/presentation/bloc/transaction_bloc.dart';
// import 'package:prism/features/transaction/domain/usecases/delete_transaction.dart';
// import 'package:prism/features/transaction/domain/usecases/update_transaction.dart';
// import 'package:prism/features/transaction/domain/usecases/get_transactions.dart';
// import 'package:prism/features/transaction/domain/usecases/get_transaction.dart';
// import 'package:prism/features/transaction/data/datasources/remote.dart';
// import 'package:prism/features/transaction/data/datasources/local.dart';

part 'dependencies.main.dart';