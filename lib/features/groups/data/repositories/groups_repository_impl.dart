/* Package Imports */
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

/* Project Imports */
import 'package:prism/features/groups/domain/repositories/groups_repository.dart';
import 'package:prism/features/finance/domain/entities/expense.dart';
import 'package:prism/features/groups/data/datasources/remote.dart';
import 'package:prism/features/groups/domain/entities/group.dart';
import 'package:prism/features/groups/data/models/group.dart';
import 'package:prism/core/network/connection_checker.dart';
import 'package:prism/features/auth/data/models/user.dart';
import 'package:prism/core/common/entities/user.dart';
import 'package:prism/core/constants/constants.dart';
import 'package:prism/core/errors/exceptions.dart';
import 'package:prism/core/errors/failures.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource _groupRemoteDataSource;
  final ConnectionChecker _connectionChecker;

  const GroupRepositoryImpl(
    this._groupRemoteDataSource,
    this._connectionChecker,
  );

  @override
  Future<Either<Failure, GroupEntity>> createGroup({
    required String owner,
    required String name,
    required String description,
    required List<UserEntity> members,
  }) async {
    return _getGroupEntity(
      () async => await _groupRemoteDataSource.createGroup(
        owner: owner,
        group: GroupModel(
          id: const Uuid().v4(),
          owner: owner,
          name: name,
          description: description,
          members: members,
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, void>> removeGroup({
    required String owner,
    required String id,
  }) async {
    try {
      if (!await _connectionChecker.connected) {
        return left(Failure(Constants.connectionError));
      }

      await _groupRemoteDataSource.removeGroup(
        owner: owner,
        groupId: id,
      );
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, GroupEntity>> updateGroup({
    required String owner,
    required String id,
    required String name,
    required String description,
    required List<UserEntity> members,
  }) async {
    return _getGroupEntity(
      () async => await _groupRemoteDataSource.updateGroup(
        owner: owner,
        group: GroupModel(
          id: id,
          owner: owner,
          name: name,
          description: description,
          members: members,
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, GroupEntity>> getGroup({
    required String owner,
    required String id,
  }) async {
    return _getGroupEntity(
      () async => await _groupRemoteDataSource.getGroup(
        owner: owner,
        groupId: id,
      ),
    );
  }

  @override
  Future<Either<Failure, List<GroupEntity>>> getGroups({
    required String owner,
  }) async {
    try {
      if (!await _connectionChecker.connected) {
        return left(Failure(Constants.connectionError));
      }

      final groups = await _groupRemoteDataSource.getGroups(
        owner: owner,
      );

      return right(groups);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getGroupMembers({
    required String owner,
    required String id,
  }) async {
    try {
      if (!await _connectionChecker.connected) {
        return left(Failure(Constants.connectionError));
      }

      final members = await _groupRemoteDataSource.getGroupMembers(
        owner: owner,
        groupId: id,
      );

      return right(members);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addGroupMember({
    required String owner,
    required String id,
    required UserEntity user,
  }) async {
    try {
      if (!await _connectionChecker.connected) {
        return left(Failure(Constants.connectionError));
      }

      await _groupRemoteDataSource.addGroupMember(
        owner: owner,
        groupId: id,
        user: UserModel.fromEntity(user),
      );

      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeGroupMember({
    required String owner,
    required String id,
    required UserEntity user,
  }) async {
    try {
      if (!await _connectionChecker.connected) {
        return left(Failure(Constants.connectionError));
      }

      await _groupRemoteDataSource.removeGroupMember(
        owner: owner,
        groupId: id,
        user: UserModel.fromEntity(user),
      );

      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ExpenseEntity>>> getGroupExpenses({
    required String owner,
    required String id,
  }) async {
    try {
      if (!await _connectionChecker.connected) {
        return left(Failure(Constants.connectionError));
      }

      final expenses = await _groupRemoteDataSource.getGroupExpenses(
        owner: owner,
        groupId: id,
      );

      return right(expenses);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, GroupEntity>> _getGroupEntity(
    Future<GroupModel> Function() getGroup,
  ) async {
    try {
      if (!await _connectionChecker.connected) {
        return left(Failure(Constants.connectionError));
      }

      final group = await getGroup();

      return right(group);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
