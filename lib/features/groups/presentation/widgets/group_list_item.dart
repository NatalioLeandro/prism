/* Flutter Imports */
import 'package:flutter/material.dart';

/* Project Imports */
import 'package:prism/features/groups/domain/entities/group.dart';
import 'package:prism/config/routes/router.dart' as routes;

class GroupListItem extends StatelessWidget {
  final GroupEntity group;

  const GroupListItem({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        8.0,
        4.0,
        8.0,
        4.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Column(
            children: [
              Text(
                group.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const Divider(),
            ],
          ),
          subtitle: Column(
            children: [
              Text(group.description),
            ],
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              routes.groupDetail,
              arguments: group,
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          splashColor: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
