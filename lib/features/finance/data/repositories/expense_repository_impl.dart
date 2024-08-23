/* Package Imports */
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

/* Project Imports */
import 'package:prism/features/finance/domain/repositories/expense_repository.dart';
import 'package:prism/features/finance/data/datasources/remote.dart';
import 'package:prism/features/finance/domain/entities/expense.dart';
import 'package:prism/features/finance/data/models/expense.dart';
import 'package:prism/core/network/connection_checker.dart';
import 'package:prism/core/constants/constants.dart';
import 'package:prism/core/errors/exceptions.dart';
import 'package:prism/core/errors/failures.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource _expenseRemoteDataSource;
  final ConnectionChecker _connectionChecker;

  const ExpenseRepositoryImpl(
    this._expenseRemoteDataSource,
    this._connectionChecker,
  );

  @override
  Future<Either<Failure, ExpenseEntity>> createExpense({
    required String userId,
    required title,
    required double amount,
    required DateTime date,
    required String groupId,
    required category,
  }) async {
    return _getExpenseEntity(
      () async => await _expenseRemoteDataSource.createExpense(
        userId: userId,
        expense: ExpenseModel(
          id: const Uuid().v4(),
          title: title,
          amount: amount,
          groupId: groupId,
          date: date,
          category: category,
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, void>> removeExpense({
    required String userId,
    required String id,
  }) async {
    try {
      if (!await _connectionChecker.connected) {
        return left(Failure(Constants.connectionError));
      }

      await _expenseRemoteDataSource.removeExpense(
        userId: userId,
        expenseId: id,
      );

      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, ExpenseEntity>> getExpense({
    required String userId,
    required String id,
  }) async {
    return _getExpenseEntity(
      () async => await _expenseRemoteDataSource.getExpense(
        userId: userId,
        expenseId: id,
      ),
    );
  }

  @override
  Future<Either<Failure, List<ExpenseEntity>>> getExpenses({
    required String userId,
  }) async {
    try {
      if (!await _connectionChecker.connected) {
        return left(Failure(Constants.connectionError));
      }
      final expenses = await _expenseRemoteDataSource.getExpenses(
        userId: userId,
      );
      return right(expenses);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, ExpenseEntity>> updateExpense({
    required String userId,
    required String id,
    required title,
    required double amount,
    required String groupId,
    required DateTime date,
    required category,
  }) async {
    return _getExpenseEntity(
      () async => await _expenseRemoteDataSource.updateExpense(
        userId: userId,
        expense: ExpenseModel(
          id: id,
          title: title,
          amount: amount,
          groupId: groupId,
          date: date,
          category: category,
        ),
      ),
    );
  }

  Future<Either<Failure, ExpenseEntity>> _getExpenseEntity(
    Future<ExpenseEntity> Function() getExpense,
  ) async {
    try {
      if (!await _connectionChecker.connected) {
        return left(Failure(Constants.connectionError));
      }

      final expense = await getExpense();

      return right(expense);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
