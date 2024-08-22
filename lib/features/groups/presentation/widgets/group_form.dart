/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:prism/core/common/cubit/user/user_cubit.dart';
import 'package:prism/core/common/widgets/form_field.dart';
import 'package:prism/core/common/widgets/button.dart';

class GroupForm extends StatefulWidget {
  const GroupForm({
    super.key,
  });

  @override
  State<GroupForm> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomFormField(
            hint: 'Digite o nome',
            label: 'Nome',
            icon: Icons.group,
            controller: _nameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Campo obrigatório';
              }
              return null;
            },
          ),
          CustomFormField(
            hint: 'Digite a descrição',
            label: 'Descrição',
            icon: Icons.description,
            controller: _descriptionController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Campo obrigatório';
              }
              return null;
            },
          ),
          CustomButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final user = context.read<UserCubit>().state;
                context.read<GroupsBloc>().add(
                      GroupsCreateEvent(
                        userId: user.id,
                        name: _nameController.text,
                        description: _descriptionController.text,
                        members: [user.id],
                      ),
                    );
              }
            },
            text: 'Criar Grupo',
          ),
        ],
      ),
    );
  }
}
