/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/features/groups/domain/usecases/remove_group_member.dart';
import 'package:prism/features/groups/domain/usecases/get_group_expenses.dart';
import 'package:prism/features/groups/domain/usecases/get_group_members.dart';
import 'package:prism/features/groups/domain/usecases/add_group_member.dart';
import 'package:prism/features/groups/domain/usecases/update_group.dart';
import 'package:prism/features/groups/domain/usecases/remove_group.dart';
import 'package:prism/features/groups/domain/usecases/create_group.dart';
import 'package:prism/features/groups/domain/usecases/get_groups.dart';
import 'package:prism/features/groups/domain/usecases/get_group.dart';
import 'package:prism/features/finance/domain/entities/expense.dart';
import 'package:prism/features/groups/domain/entities/group.dart';
import 'package:prism/core/common/entities/user.dart';

part 'groups_event.dart';

part 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  final CreateGroup _createGroup;
  final RemoveGroup _removeGroup;
  final UpdateGroup _updateGroup;
  final GetGroup _getGroup;
  final GetGroups _getGroups;
  final GetGroupMembers _getGroupMembers;
  final AddGroupMember _addGroupMember;
  final RemoveGroupMember _removeGroupMember;
  final GetGroupExpenses _getGroupExpenses;

  GroupsBloc({
    required CreateGroup createGroup,
    required RemoveGroup removeGroup,
    required UpdateGroup updateGroup,
    required GetGroup getGroup,
    required GetGroups getGroups,
    required GetGroupMembers getGroupMembers,
    required AddGroupMember addGroupMember,
    required RemoveGroupMember removeGroupMember,
    required GetGroupExpenses getGroupExpenses,
  })  : _createGroup = createGroup,
        _removeGroup = removeGroup,
        _updateGroup = updateGroup,
        _getGroup = getGroup,
        _getGroups = getGroups,
        _getGroupMembers = getGroupMembers,
        _addGroupMember = addGroupMember,
        _removeGroupMember = removeGroupMember,
        _getGroupExpenses = getGroupExpenses,
        super(GroupsInitialState()) {
    on<GroupsEvent>((event, emit) => emit(GroupsLoadingState()));
    on<GroupsCreateEvent>(_create);
    on<GroupsRemoveEvent>(_remove);
    on<GroupsUpdateEvent>(_update);
    on<GroupsGetEvent>(_get);
    on<GroupsGetAllEvent>(_getAll);
    on<GroupsGetMembersEvent>(_getMembers);
    on<GroupsAddMemberEvent>(_addMember);
    on<GroupsRemoveMemberEvent>(_removeMember);
    on<GroupsGetExpensesEvent>(_getExpenses);
  }

  void _create(
    GroupsCreateEvent event,
    Emitter<GroupsState> emit,
  ) async {
    final result = await _createGroup(
      CreateGroupParams(
        userId: event.userId,
        name: event.name,
        description: event.description,
        members: event.members,
      ),
    );
    result.fold(
      (failure) => emit(GroupsErrorState(failure.message)),
      (group) => emit(GroupsCreateSuccessState(group)),
    );
  }

  void _remove(
    GroupsRemoveEvent event,
    Emitter<GroupsState> emit,
  ) async {
    final result = await _removeGroup(
      RemoveGroupParams(
        userId: event.userId,
        id: event.id,
      ),
    );
    result.fold(
      (failure) => emit(GroupsErrorState(failure.message)),
      (_) => emit(GroupsRemoveSuccessState()),
    );
  }

  void _update(
    GroupsUpdateEvent event,
    Emitter<GroupsState> emit,
  ) async {
    final result = await _updateGroup(
      UpdateGroupParams(
        userId: event.userId,
        id: event.id,
        name: event.name,
        description: event.description,
        members: event.members,
      ),
    );
    result.fold(
      (failure) => emit(GroupsErrorState(failure.message)),
      (group) => emit(GroupsUpdateSuccessState(group)),
    );
  }

  void _get(
    GroupsGetEvent event,
    Emitter<GroupsState> emit,
  ) async {
    final result = await _getGroup(
      GetGroupParams(
        owner: event.userId,
        id: event.id,
      ),
    );
    result.fold(
      (failure) => emit(GroupsErrorState(failure.message)),
      (group) => emit(GroupsGetSuccessState(group)),
    );
  }

  void _getAll(
    GroupsGetAllEvent event,
    Emitter<GroupsState> emit,
  ) async {
    final result = await _getGroups(
      GetGroupsParams(
        owner: event.userId,
      ),
    );
    result.fold(
      (failure) => emit(GroupsErrorState(failure.message)),
      (groups) => emit(GroupsSuccessState(groups)),
    );
  }

  void _getMembers(
    GroupsGetMembersEvent event,
    Emitter<GroupsState> emit,
  ) async {
    final result = await _getGroupMembers(
      GetGroupMembersParams(
        owner: event.userId,
        id: event.id,
      ),
    );
    result.fold(
      (failure) => emit(GroupsErrorState(failure.message)),
      (members) => emit(GroupsGetMembersSuccessState(members)),
    );
  }

  void _addMember(
    GroupsAddMemberEvent event,
    Emitter<GroupsState> emit,
  ) async {
    final result = await _addGroupMember(
      AddGroupMemberParams(
        owner: event.userId,
        id: event.id,
        user: event.user,
      ),
    );
    result.fold(
      (failure) => emit(GroupsErrorState(failure.message)),
      (_) => emit(GroupsAddMemberSuccessState()),
    );
  }

  void _removeMember(
    GroupsRemoveMemberEvent event,
    Emitter<GroupsState> emit,
  ) async {
    final result = await _removeGroupMember(
      RemoveGroupMemberParams(
        owner: event.userId,
        id: event.id,
        user: event.member,
      ),
    );
    result.fold(
      (failure) => emit(GroupsErrorState(failure.message)),
      (_) => emit(GroupsRemoveMemberSuccessState()),
    );
  }

  void _getExpenses(
    GroupsGetExpensesEvent event,
    Emitter<GroupsState> emit,
  ) async {
    final result = await _getGroupExpenses(
      GetGroupExpensesParams(
        owner: event.userId,
        id: event.id,
      ),
    );
    result.fold(
      (failure) => emit(GroupsErrorState(failure.message)),
      (expenses) => emit(GroupsGetExpensesSuccessState(expenses)),
    );
  }
}
