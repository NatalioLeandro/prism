/* Package Imports */
import 'package:cloud_firestore/cloud_firestore.dart';

/* Project Imports */
import 'package:prism/features/finance/data/models/expense.dart';
import 'package:prism/core/errors/exceptions.dart';

abstract interface class ExpenseRemoteDataSource {
  Future<ExpenseModel> createExpense({
    required String userId,
    required ExpenseModel expense,
  });

  Future<void> removeExpense({
    required String userId,
    required String expenseId,
  });

  Future<ExpenseModel> getExpense({
    required String userId,
    required String expenseId,
  });

  Future<List<ExpenseModel>> getExpenses({
    required String userId,
  });

  Future<ExpenseModel> updateExpense({
    required String userId,
    required ExpenseModel expense,
  });
}

class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final FirebaseFirestore _firestore;

  ExpenseRemoteDataSourceImpl(this._firestore);

  @override
  Future<ExpenseModel> createExpense({
    required String userId,
    required ExpenseModel expense,
  }) async {
    try {
      final expenseId = expense.id;
      final expenseCollection = _firestore.collection('users/$userId/expenses');
      await expenseCollection.doc(expenseId).set(expense.toJson());

      return expense;
    } on FirebaseException catch (e) {
      throw ServerException(e.message.toString());
    }
  }

  @override
  Future<void> removeExpense({
    required String userId,
    required String expenseId,
  }) async {
    try {
      final expenseDocument =
          _firestore.doc('users/$userId/expenses/$expenseId');
      await expenseDocument.delete();
    } on FirebaseException catch (e) {
      throw ServerException(e.message.toString());
    }
  }

  @override
  Future<ExpenseModel> getExpense({
    required String userId,
    required String expenseId,
  }) async {
    try {
      final expenseDocument =
          await _firestore.doc('users/$userId/expenses/$expenseId').get();
      final expenseData = expenseDocument.data()!;

      return ExpenseModel.fromJson(expenseData);
    } on FirebaseException catch (e) {
      throw ServerException(e.message.toString());
    }
  }

  @override
  Future<List<ExpenseModel>> getExpenses({
    required String userId,
  }) async {
    try {
      final expensesCollection =
          await _firestore.collection('users/$userId/expenses').get();
      final expensesData =
          expensesCollection.docs.map((doc) => doc.data()).toList();
      return expensesData.map((data) => ExpenseModel.fromJson(data)).toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message.toString());
    }
  }

  @override
  Future<ExpenseModel> updateExpense({
    required String userId,
    required ExpenseModel expense,
  }) async {
    try {
      final expenseDocument =
          _firestore.doc('users/$userId/expenses/${expense.id}');
      await expenseDocument.update(expense.toJson());

      return expense;
    } on FirebaseException catch (e) {
      throw ServerException(e.message.toString());
    }
  }
}
