/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:prism/core/common/cubit/user/user_cubit.dart';
import 'package:prism/core/common/widgets/form_field.dart';
import 'package:prism/core/common/widgets/button.dart';

class GroupMemberForm extends StatefulWidget {
  const GroupMemberForm({
    super.key,
  });

  @override
  State<GroupMemberForm> createState() => _GroupMemberFormState();
}

class _GroupMemberFormState extends State<GroupMemberForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final user = context.read<UserCubit>().state;
                context.read<GroupsBloc>().add(
                  GroupsAddMemberEvent(
                    userId: user.id,
                    id: "d6d62660-daae-40ad-8ead-e45debab5c4f"
                    ,
                    user: 'a7Lp2Hx4gbWTJdw0LCVt1qzRk0F3',
                  ),
                );
              }
            },
            text: 'add member',
          ),
        ],
      ),
    );
  }
}
