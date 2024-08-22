part of 'groups_bloc.dart';

@immutable
abstract class GroupsState {
  const GroupsState();
}

class GroupsInitialState extends GroupsState {}

class GroupsLoadingState extends GroupsState {}

class GroupsErrorState extends GroupsState {
  final String message;

  const GroupsErrorState(this.message);
}

class GroupsSuccessState extends GroupsState {
  final List<GroupEntity> groups;

  const GroupsSuccessState(this.groups);
}

class GroupsCreateSuccessState extends GroupsState {
  final GroupEntity group;

  const GroupsCreateSuccessState(this.group);
}

class GroupsUpdateSuccessState extends GroupsState {
  final GroupEntity group;

  const GroupsUpdateSuccessState(this.group);
}

class GroupsRemoveSuccessState extends GroupsState {}

class GroupsGetSuccessState extends GroupsState {
  final GroupEntity group;

  const GroupsGetSuccessState(this.group);
}

class GroupsGetMembersSuccessState extends GroupsState {
  final List<UserEntity> members;

  const GroupsGetMembersSuccessState(this.members);
}

class GroupsAddMemberSuccessState extends GroupsState {}

class GroupsRemoveMemberSuccessState extends GroupsState {
}

class GroupsGetExpensesSuccessState extends GroupsState {
  final List<ExpenseEntity> expenses;

  const GroupsGetExpensesSuccessState(this.expenses);
}

class GroupsGetUserSuccessState extends GroupsState {
  final UserEntity user;

  const GroupsGetUserSuccessState(this.user);
}
