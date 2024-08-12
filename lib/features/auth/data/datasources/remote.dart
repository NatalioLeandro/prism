/* Package Imports */
import 'package:firebase_auth/firebase_auth.dart';

/* Project Imports */
import 'package:prism/features/auth/data/models/user.dart';
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
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;

  AuthRemoteDataSourceImpl(this._auth);

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

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw ServerException('E-mail inválido');
      } else if (e.code == 'invalid-credential') {
        throw ServerException('Credenciais inválidas');
      } else {
        throw ServerException(e.message as String);
      }
    } catch (e) {
      throw ServerException(e.toString());
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

      return UserModel.fromFirebaseUser(updatedUser!);
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
      return UserModel.fromFirebaseUser(user);
    }
    return null;
  }
}
