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
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
              blurRadius: 1.0,
              offset: const Offset(0.0, 1.0),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(
            Icons.group,
            color: Theme.of(context).colorScheme.secondary,
            size: 20.0,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).colorScheme.secondary,
            size: 20.0,
          ),
          title: Column(
            children: [
              Text(
                group.name.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  letterSpacing: 1.2,
                ),
              ),
              const Divider(),
            ],
          ),
          subtitle: Column(
            children: [
              Text(
                group.description[0].toUpperCase() + group.description.substring(1),
                textAlign: TextAlign.center,
              ),
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
