part of 'dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initFinances();
  _initGroups();

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
      () => UpdateUserFixedIncome(
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
        updateUserFixedIncome: serviceLocator(),
        updateUserAccountType: serviceLocator(),
        userCubit: serviceLocator(),
      ),
    );
}

void _initFinances() {
  // Data sources
  serviceLocator
    ..registerFactory<ExpenseRemoteDataSource>(
      () => ExpenseRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repositories
    ..registerFactory<ExpenseRepository>(
      () => ExpenseRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Use cases
    ..registerFactory(
      () => CreateExpense(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateExpense(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => RemoveExpense(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetExpenses(
        serviceLocator(),
      ),
    )
    ..registerFactory(() => GetExpense(
          serviceLocator(),
        ))
    // Bloc
    ..registerLazySingleton(
      () => FinanceBloc(
        createExpense: serviceLocator(),
        updateExpense: serviceLocator(),
        removeExpense: serviceLocator(),
        getExpenses: serviceLocator(),
        getExpense: serviceLocator(),
      ),
    );
}

void _initGroups() {
  // Data sources
  serviceLocator
    ..registerFactory<GroupRemoteDataSource>(
      () => GroupRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repositories
    ..registerFactory<GroupRepository>(
      () => GroupRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Use cases
    ..registerFactory(
      () => CreateGroup(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => RemoveGroup(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateGroup(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetGroup(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetGroups(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetGroupMembers(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => AddGroupMember(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => RemoveGroupMember(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetGroupExpenses(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => GroupsBloc(
        createGroup: serviceLocator(),
        removeGroup: serviceLocator(),
        updateGroup: serviceLocator(),
        getGroup: serviceLocator(),
        getGroups: serviceLocator(),
        getGroupMembers: serviceLocator(),
        addGroupMember: serviceLocator(),
        removeGroupMember: serviceLocator(),
        getGroupExpenses: serviceLocator(),
      ),
    );
}
