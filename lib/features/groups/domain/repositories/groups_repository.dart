/* Package Imports */
import 'package:fpdart/fpdart.dart';

/* Project Imports */
import 'package:prism/features/finance/domain/entities/expense.dart';
import 'package:prism/features/groups/domain/entities/group.dart';
import 'package:prism/core/common/entities/user.dart';
import 'package:prism/core/errors/failures.dart';

abstract interface class GroupRepository {
  Future<Either<Failure, GroupEntity>> createGroup({
    required String owner,
    required String name,
    required String description,
    required List<UserEntity> members,
  });

  Future<Either<Failure, void>> removeGroup({
    required String owner,
    required String id,
  });

  Future<Either<Failure, GroupEntity>> updateGroup({
    required String owner,
    required String id,
    required String name,
    required String description,
    required List<UserEntity> members,
  });

  Future<Either<Failure, GroupEntity>> getGroup({
    required String owner,
    required String id,
  });

  Future<Either<Failure, List<GroupEntity>>> getGroups({
    required String owner,
  });

  Future<Either<Failure, List<UserEntity>>> getGroupMembers({
    required String owner,
    required String id,
  });

  Future<Either<Failure, void>> addGroupMember({
    required String owner,
    required String id,
    required UserEntity user,
  });

  Future<Either<Failure, void>> removeGroupMember({
    required String owner,
    required String id,
    required UserEntity user,
  });

  Future<Either<Failure, List<ExpenseEntity>>> getGroupExpenses({
    required String owner,
    required String id,
  });
}