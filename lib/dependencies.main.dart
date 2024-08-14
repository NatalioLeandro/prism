part of 'dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  // _initTransaction();

  serviceLocator.registerLazySingleton(
    () => FirebaseAuth.instance,
  );

  serviceLocator.registerLazySingleton(
    () => FirebaseFirestore.instance,
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(
    () => sharedPreferences,
  );

  serviceLocator.registerLazySingleton(
    () => UserCubit(),
  );

  serviceLocator.registerLazySingleton(
    () => ThemeCubit(),
  );

  serviceLocator.registerFactory(
    () => Connectivity(),
  );

  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );
}

void _initAuth() {
  // Data sources
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Repositories
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Use cases
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserRegister(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogout(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserPasswordRecover(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateUserBalance(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateUserAccountType(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userLogin: serviceLocator(),
        userRegister: serviceLocator(),
        currentUser: serviceLocator(),
        userLogout: serviceLocator(),
        userPasswordRecover: serviceLocator(),
        updateUserBalance: serviceLocator(),
        updateUserAccountType: serviceLocator(),
        userCubit: serviceLocator(),
      ),
    );
}

// void _initTransaction() {
//   // Data sources
//   serviceLocator
//     ..registerFactory<TransactionRemoteDataSource>(
//       () => TransactionRemoteDataSourceImpl(
//         serviceLocator(),
//       ),
//     )
//     ..registerFactory<TransactionLocalDataSource>(
//       () => TransactionLocalDataSourceImpl(
//         serviceLocator(),
//       ),
//     )
//     // Repositories
//     ..registerFactory<TransactionRepository>(
//       () => TransactionRepositoryImpl(
//         serviceLocator(),
//         serviceLocator(),
//         serviceLocator(),
//       ),
//     )
//     // Use cases
//     ..registerFactory(
//       () => CreateTransaction(
//         serviceLocator(),
//       ),
//     )
//     ..registerFactory(
//       () => GetTransactions(
//         serviceLocator(),
//       ),
//     )
//     ..registerFactory(
//       () => GetTransaction(
//         serviceLocator(),
//       ),
//     )
//     ..registerFactory(
//       () => UpdateTransaction(
//         serviceLocator(),
//       ),
//     )
//     ..registerFactory(
//       () => DeleteTransaction(
//         serviceLocator(),
//       ),
//     )
//     // Bloc
//     ..registerLazySingleton(
//       () => TransactionBloc(
//         createTransaction: serviceLocator(),
//         getTransactions: serviceLocator(),
//         getTransaction: serviceLocator(),
//         updateTransaction: serviceLocator(),
//         deleteTransaction: serviceLocator(),
//       ),
//     );
// }
