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
    required String user,
  });

  Future<void> removeGroupMember({
    required String owner,
    required String groupId,
    required String user,
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
      final groupId = group.id;
      final groupCollection = _firestore.collection('users/$owner/groups');
      await groupCollection.doc(groupId).set(group.toJson());

      return group;
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
      final groupData = await groupDocument.get();
      final members = groupData.data()!['members'] as List<dynamic>;

      await Future.wait(
        members.map((member) async {
          final memberDocument = _firestore.doc('users/$member/groups/$groupId');
          await memberDocument.delete();
        }),
      );

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
      final groupsData = groupCollection.docs.map((doc) => doc.data()).toList();
      return groupsData.map((group) => GroupModel.fromJson(group)).toList();
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
      final group = await _firestore.doc('users/$owner/groups/$groupId').get();
      final members = group.data()!['members'] as List<dynamic>;

      final membersData = await Future.wait(
        members.map((member) async {
          final memberDocument = await _firestore.doc('users/$member').get();
          final memberData = memberDocument.data() as Map<String, dynamic>;
          return UserModel.fromJson(memberData);
        }),
      );

      return membersData;
    } on FirebaseException catch (e) {
      throw ServerException(e.message.toString());
    }
  }

  @override
  Future<void> addGroupMember({
    required String owner,
    required String groupId,
    required String user,
  }) async {
    try {
      final document = _firestore.doc('users/$owner/groups/$groupId');

      final groupMembers = await document.get();
      final members = groupMembers.data()!['members'] as List<dynamic>;
      if (members.contains(user)) {
        return;
      }

      await document.update({
        'members': FieldValue.arrayUnion([user]),
      });

      final newDocument = _firestore.doc('users/$owner/groups/$groupId');
      final group = await newDocument.get();
      final groupData = group.data() as Map<String, dynamic>;

      final newDocumentMember = _firestore.doc('users/$user/groups/$groupId');
      await newDocumentMember.set(groupData);
    } on FirebaseException catch (e) {
      throw ServerException(e.message.toString());
    }
  }

  @override
  Future<void> removeGroupMember({
    required String owner,
    required String groupId,
    required String user,
  }) async {
    try {
      final document = _firestore.doc('users/$owner/groups/$groupId');
      await document.update({
        'members': FieldValue.arrayRemove([user]),
      });

      final memberDocument = _firestore.doc('users/$user/groups/$groupId');
      await memberDocument.delete();

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
      final ownerExpensesCollection =
          await _firestore.collection('users/$owner/expenses').get();
      final ownerExpensesData =
      ownerExpensesCollection.docs.map((doc) => doc.data()).toList();

      final ownerExpenses = ownerExpensesData
          .where((expense) => expense['groupId'] == groupId)
          .toList();

      final members = await getGroupMembers(owner: owner, groupId: groupId);
      final memberIds = members.map((member) => member.id).toList();

      final membersExpenses = await Future.wait(
        memberIds.map((memberId) async {
          final memberExpensesCollection =
              await _firestore.collection('users/$memberId/expenses').get();
          final memberExpensesData =
              memberExpensesCollection.docs.map((doc) => doc.data()).toList();

          return memberExpensesData
              .where((expense) => expense['groupId'] == groupId)
              .toList();
        }),
      );

      final groupExpenses = ownerExpenses + membersExpenses.expand((element) => element).toList();

      final groupExpensesMap = groupExpenses.fold<Map<String, dynamic>>(
        {},
        (acc, expense) {
          final id = expense['id'];
          if (!acc.containsKey(id)) {
            acc[id] = expense;
          }
          return acc;
        },
      );

      return groupExpensesMap.values.map((expense) => ExpenseModel.fromJson(expense)).toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message.toString());
    }
  }
}
