part of 'groups_bloc.dart';

@immutable
abstract class GroupsEvent {}

class GroupsLoadEvent extends GroupsEvent {
  final String userId;

  GroupsLoadEvent({
    required this.userId,
  });
}

class GroupsCreateEvent extends GroupsEvent {
  final String userId;
  final String name;
  final String description;
  final List<String> members;

  GroupsCreateEvent({
    required this.userId,
    required this.name,
    required this.description,
    required this.members,
  });
}

class GroupsRemoveEvent extends GroupsEvent {
  final String userId;
  final String id;

  GroupsRemoveEvent({
    required this.userId,
    required this.id,
  });
}

class GroupsUpdateEvent extends GroupsEvent {
  final String userId;
  final String id;
  final String name;
  final String description;
  final List<String> members;

  GroupsUpdateEvent({
    required this.userId,
    required this.id,
    required this.name,
    required this.description,
    required this.members,
  });
}

class GroupsGetEvent extends GroupsEvent {
  final String userId;
  final String id;

  GroupsGetEvent({
    required this.userId,
    required this.id,
  });
}

class GroupsGetAllEvent extends GroupsEvent {
  final String userId;

  GroupsGetAllEvent({
    required this.userId,
  });
}

class GroupsGetMembersEvent extends GroupsEvent {
  final String userId;
  final String id;

  GroupsGetMembersEvent({
    required this.userId,
    required this.id,
  });
}

class GroupsAddMemberEvent extends GroupsEvent {
  final String userId;
  final String id;
  final String user;

  GroupsAddMemberEvent({
    required this.userId,
    required this.id,
    required this.user,
  });
}

class GroupsRemoveMemberEvent extends GroupsEvent {
  final String userId;
  final String id;
  final String member;

  GroupsRemoveMemberEvent({
    required this.userId,
    required this.id,
    required this.member,
  });
}

class GroupsGetExpensesEvent extends GroupsEvent {
  final String userId;
  final String id;

  GroupsGetExpensesEvent({
    required this.userId,
    required this.id,
  });
}

class GroupsGetUserEvent extends GroupsEvent {
  final String id;

  GroupsGetUserEvent({
    required this.id,
  });
}
