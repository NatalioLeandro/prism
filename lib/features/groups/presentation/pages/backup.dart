/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/features/groups//presentation/widgets/group_form.dart';
import 'package:prism/features/groups/presentation/widgets/add_member.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: SingleChildScrollView(
          child: Column(
            children: [
              GroupForm(),
              GroupMemberForm()
            ],
          )
      ),
    );
  }
}
