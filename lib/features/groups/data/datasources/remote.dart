/* Package Imports */
import 'package:cloud_firestore/cloud_firestore.dart';

/* Project Imports */
import 'package:prism/features/finance/data/models/expense.dart';
import 'package:prism/features/groups/data/models/group.dart';
import 'package:prism/features/auth/data/models/user.dart';
import 'package:prism/core/errors/exceptions.dart';

abstract interface class GroupRemoteDataSource {
  Future<GroupModel> createGroup({
    required String owner,
    required GroupModel group,
  });

  Future<void> removeGroup({
    required String owner,
    required String groupId,
  });

  Future<GroupModel> getGroup({
    required String owner,
    required String groupId,
  });

  Future<List<GroupModel>> getGroups({
    required String owner,
  });

  Future<GroupModel> updateGroup({
    required String owner,
    required GroupModel group,
  });

  Future<List<UserModel>> getGroupMembers({
    required String owner,
    required String groupId,
  });

  Future<void> addGroupMember({
    required String owner,
    required String groupId,
    required UserModel user,
  });

  Future<void> removeGroupMember({
    required String owner,
    required String groupId,
    required UserModel user,
  });

  Future<List<ExpenseModel>> getGroupExpenses({
    required String owner,
    required String groupId,
  });
}

class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  final FirebaseFirestore _firestore;

  GroupRemoteDataSourceImpl(this._firestore);

  @override
  Future<GroupModel> createGroup({
    required String owner,
    required GroupModel group,
  }) async {
    try {
      final groupCollection = _firestore.collection('users/$owner/groups');
      final groupDocument = await groupCollection.add(group.toJson());

      return group.copyWith(id: groupDocument.id);
    } on FirebaseException catch (e) {
      throw ServerException(e.message.toString());
    }
  }

  @override
  Future<void> removeGroup({
    required String owner,
    required String groupId,
  }) async {
    try {
      final groupDocument = _firestore.doc('users/$owner/groups/$groupId');
      await groupDocument.delete();
    } on FirebaseException catch (e) {
      throw ServerException(e.message.toString());
    }
  }

  @override
  Future<GroupModel> getGroup({
    required String owner,
    required String groupId,
  }) async {
    try {
      final groupDocument =
          await _firestore.doc('users/$owner/groups/$groupId').get();
      final groupData = groupDocument.data() as Map<String, dynamic>;

      return GroupModel.fromJson(groupData);
    } on FirebaseException catch (e) {
      throw ServerException(e.message.toString());
    }
  }

  @override
  Future<List<GroupModel>> getGroups({
    required String owner,
  }) async {
    try {
      final groupCollection =
          await _firestore.collection('users/$owner/groups').get();
      final groupData = groupCollection.docs.map((doc) => doc.data()).toList();

      return groupData.map((group) => GroupModel.fromJson(group)).toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message.toString());
    }
  }

  @override
  Future<GroupModel> updateGroup({
    required String owner,
    required GroupModel group,
  }) async {
    try {
      final groupDocument = _firestore.doc('users/$owner/groups/${group.id}');
      await groupDocument.update(group.toJson());

      return group;
    } on FirebaseException catch (e) {
      throw ServerException(e.message.toString());
    }
  }

  @override
  Future<List<UserModel>> getGroupMembers({
    required String owner,
    required String groupId,
  }) async {
    try {
      final groupMembers = await _firestore
          .collection('users/$owner/groups/$groupId/members')
          .get();
      final membersData = groupMembers.docs.map((doc) => doc.data()).toList();

      return membersData.map((member) => UserModel.fromJson(member)).toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message.toString());
    }
  }

  @override
  Future<void> addGroupMember({
    required String owner,
    required String groupId,
    required UserModel user,
  }) async {
    try {
      final groupMembers =
          _firestore.collection('users/$owner/groups/$groupId/members');
      await groupMembers.add(user.toJson());
    } on FirebaseException catch (e) {
      throw ServerException(e.message.toString());
    }
  }

  @override
  Future<void> removeGroupMember({
    required String owner,
    required String groupId,
    required UserModel user,
  }) async {
    try {
      final groupMembers =
          _firestore.collection('users/$owner/groups/$groupId/members');
      final memberDocument =
          await groupMembers.where('id', isEqualTo: user.id).get();
      await memberDocument.docs.first.reference.delete();
    } on FirebaseException catch (e) {
      throw ServerException(e.message.toString());
    }
  }

  @override
  Future<List<ExpenseModel>> getGroupExpenses({
    required String owner,
    required String groupId,
  }) async {
    try {
      final groupExpenses = await _firestore
          .collection('users/$owner/groups/$groupId/expenses')
          .get();
      final expensesData = groupExpenses.docs.map((doc) => doc.data()).toList();

      return expensesData
          .map((expense) => ExpenseModel.fromJson(expense))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message.toString());
    }
  }
}
