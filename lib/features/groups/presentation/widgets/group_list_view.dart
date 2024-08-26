/* Flutter Imports */
import 'package:flutter/material.dart';

/* Project Imports */
import 'package:prism/features/groups/presentation/widgets/group_list_item.dart';
import 'package:prism/features/groups/domain/entities/group.dart';

class GroupListView extends StatelessWidget {
  final List<GroupEntity> groups;

  const GroupListView({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              return GroupListItem(group: groups[index]);
            },
          ),
        ),
      ],
    );
  }
}
