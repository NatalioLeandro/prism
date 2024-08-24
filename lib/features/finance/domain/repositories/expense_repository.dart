/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/finance/domain/entities/expense.dart';
import 'package:prism/core/enums/expense_category.dart';
import 'package:prism/core/enums/expense_type.dart';
import 'package:prism/core/errors/failures.dart';

abstract interface class ExpenseRepository {
  Future<Either<Failure, ExpenseEntity>> createExpense({
    required String userId,
    required String title,
    required double amount,
    required String groupId,
    required DateTime date,
    required ExpenseCategory category,
    required ExpenseType type,
  });

  Future<Either<Failure, void>> removeExpense({
    required String userId,
    required String id,
  });

  Future<Either<Failure, ExpenseEntity>> updateExpense({
    required String userId,
    required String id,
    required String title,
    required double amount,
    required String groupId,
    required DateTime date,
    required ExpenseCategory category,
    required ExpenseType type,
  });

  Future<Either<Failure, ExpenseEntity>> getExpense({
    required String userId,
    required String id,
  });

  Future<Either<Failure, List<ExpenseEntity>>> getExpenses({
    required String userId,
  });
}
