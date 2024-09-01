/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:prism/core/common/entities/user.dart';

class MemberCard extends StatelessWidget {
  final UserEntity member;
  final String groupId;
  final String ownerId;
  final String currentUserId;

  const MemberCard({
    super.key,
    required this.member,
    required this.groupId,
    required this.ownerId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    bool isOwner = currentUserId == ownerId;
    bool isCurrentUser = currentUserId == member.id;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        title: Text(
          member.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          member.email,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 14,
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Text(
            member.name.isNotEmpty ? member.name[0] : '?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: 18,
            ),
          ),
        ),
        trailing: isOwner && !isCurrentUser
            ? _buildRemoveMemberButton(context)
            : isCurrentUser
                ? _buildLeaveGroupButton(context)
                : null,
      ),
    );
  }

  Widget _buildRemoveMemberButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.remove_circle_outline,
        color: Theme.of(context).colorScheme.error,
      ),
      onPressed: () {
        _showRemoveDialog(context);
      },
    );
  }

  Widget _buildLeaveGroupButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.exit_to_app,
        color: Theme.of(context).colorScheme.error,
      ),
      onPressed: () {
        _showLeaveDialog(context);
      },
    );
  }

  void _showRemoveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remover ${member.name}?'),
          content: const Text(
              'Tem certeza de que deseja remover este membro do grupo?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<GroupsBloc>().add(
                      GroupsRemoveMemberEvent(
                        userId: ownerId,
                        id: groupId,
                        member: member.id,
                      ),
                    );
                Navigator.of(context).pop();
              },
              child: Text(
                'Remover',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLeaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sair do Grupo'),
          content: const Text('Tem certeza de que deseja sair do grupo?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<GroupsBloc>().add(
                      GroupsRemoveMemberEvent(
                        userId: currentUserId,
                        id: groupId,
                        member: member.id,
                      ),
                    );
                Navigator.of(context).pop();
              },
              child: Text(
                'Sair',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
