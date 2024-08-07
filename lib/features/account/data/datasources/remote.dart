/* Package Imports */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/* Project Imports */
import 'package:prism/features/account/data/models/account.dart';
import 'package:prism/core/enums/account_type.dart';
import 'package:prism/core/errors/exceptions.dart';

abstract interface class AccountRemoteDataSource {
  Future<AccountModel> createAccount({
    required String id,
    required double balance,
    required AccountType type,
  });

  Future<AccountModel> getAccount();

  Future<AccountModel> updateAccount({
    required String id,
    required double balance,
    required AccountType type,
  });
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final FirebaseFirestore _firestore;
  final user = FirebaseAuth.instance.currentUser;

  AccountRemoteDataSourceImpl(this._firestore);

  @override
  Future<AccountModel> createAccount({
    required String id,
    required double balance,
    required AccountType type,
  }) async {
    try {
      final account = AccountModel(
        id: id,
        balance: balance,
        type: type,
      );

      await _firestore
          .collection('accounts')
          .doc(user!.uid)
          .set(account.toJson());

      return account;
    } on FirebaseException catch (e) {
      throw ServerException(e.message as String);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AccountModel> getAccount() async {
    try {
      final account =
          await _firestore.collection('accounts').doc(user!.uid).get();

      return AccountModel.fromJson(account.data() as Map<String, dynamic>);
    } on FirebaseException catch (e) {
      throw ServerException(e.message as String);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AccountModel> updateAccount({
    required String id,
    required double balance,
    required AccountType type,
  }) async {
    try {
      final account = AccountModel(
        id: id,
        balance: balance,
        type: type,
      );

      await _firestore
          .collection('accounts')
          .doc(user!.uid)
          .update(account.toJson());

      return account;
    } on FirebaseException catch (e) {
      throw ServerException(e.message as String);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
