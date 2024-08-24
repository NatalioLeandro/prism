/* Flutter Imports */
import 'package:flutter/material.dart';
import 'package:prism/features/groups/presentation/widgets/group_list.dart';

/* Package Imports */


class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GroupList(),
    );
  }
}
