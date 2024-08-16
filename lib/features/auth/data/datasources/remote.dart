/* Package Imports */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/* Project Imports */
import 'package:prism/features/auth/data/models/user.dart';
import 'package:prism/core/enums/account_type.dart';
import 'package:prism/core/errors/exceptions.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String email,
    required String name,
    required String photo,
    required String password,
  });

  Future<void> recover({
    required String email,
  });

  Future<void> logout();

  Future<UserModel?> getCurrentUserData();

  Future<UserModel> updateUserFixedIncome(
    String userId,
    double newFixedIncome,
  );

  Future<UserModel> updateUserAccountType(
    String userId,
    AccountType newAccountType,
  );
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(this._auth, this._firestore);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _getUserModelFromFirestore(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw ServerException('E-mail inválido');
      } else if (e.code == 'invalid-credential') {
        throw ServerException('Credenciais inválidas');
      } else {
        throw ServerException('$e erro desconhecido ${e.code}');
      }
    } catch (e) {
      throw ServerException('$e erro desconhecido');
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String name,
    required String photo,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.updatePhotoURL(photo);

      await userCredential.user!.reload();
      final updatedUser = _auth.currentUser;

      await _createUserDocument(updatedUser!);

      return _getUserModelFromFirestore(updatedUser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw ServerException('E-mail já em uso');
      } else if (e.code == 'weak-password') {
        throw ServerException('Senha fraca');
      } else if (e.code == 'invalid-email') {
        throw ServerException('E-mail inválido');
      } else {
        throw ServerException(e.message as String);
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<void> recover({
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw ServerException('E-mail inválido');
      } else if (e.code == 'user-not-found') {
        throw ServerException('Usuário não encontrado');
      } else {
        throw ServerException(e.message as String);
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      return _getUserModelFromFirestore(user);
    }
    return null;
  }

  @override
  Future<UserModel> updateUserFixedIncome(
    String userId,
    double newFixedIncome,
  ) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'fixedIncome': newFixedIncome,
      });
      return _getUserModelFromFirestore(_auth.currentUser!);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> updateUserAccountType(
    String userId,
    AccountType newAccountType,
  ) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'account': newAccountType.toString(),
      });
      return _getUserModelFromFirestore(_auth.currentUser!);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<UserModel> _getUserModelFromFirestore(User user) async {
    final doc = await _firestore.collection('users').doc(user.uid).get();
    return UserModel.fromJson(doc.data()!);
  }

  Future<void> _createUserDocument(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'id': user.uid,
      'email': user.email,
      'name': user.displayName,
      'photo': user.photoURL,
      'fixedIncome': 0.0,
      'account': AccountType.free.toString(),
    });
  }
}
