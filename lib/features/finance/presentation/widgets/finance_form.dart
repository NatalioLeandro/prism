/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/features/finance/presentation/bloc/finance_bloc.dart';
import 'package:prism/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:prism/core/common/widgets/radio_select_field.dart';
import 'package:prism/core/common/widgets/select_form_field.dart';
import 'package:prism/features/groups/data/models/group.dart';
import 'package:prism/core/common/cubit/user/user_cubit.dart';
import 'package:prism/core/common/widgets/date_field.dart';
import 'package:prism/core/common/widgets/form_field.dart';
import 'package:prism/core/common/widgets/button.dart';
import 'package:prism/core/constants/constants.dart';

class FinanceForm extends StatefulWidget {
  const FinanceForm({
    super.key,
  });

  @override
  State<FinanceForm> createState() => _FinanceFormState();
}

class _FinanceFormState extends State<FinanceForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _groupController = TextEditingController(text: "0");
  final _dateController = TextEditingController();
  final _categoryController = TextEditingController();
  final _typeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  void _loadGroups() {
    context.read<GroupsBloc>().add(
          GroupsGetAllEvent(
            userId: context.read<UserCubit>().state.id,
          ),
        );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _groupController.dispose();
    _dateController.dispose();
    _categoryController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomFormField(
            hint: 'Digite o título',
            label: 'Título',
            icon: Icons.title,
            controller: _titleController,
          ),
          const SizedBox(height: 10),
          CustomFormField(
            hint: 'Digite o valor',
            label: 'Valor',
            keyboardType: TextInputType.number,
            icon: Icons.monetization_on_outlined,
            controller: _amountController,
          ),
          const SizedBox(height: 10),
          DateFormField(
            hint: 'Selecione a data',
            controller: _dateController,
          ),
          const SizedBox(height: 10),
          CustomRadioFormField(
            hint: 'Selecione o tipo',
            options: Constants().typeMap.keys.toList(),
            groupValue: _typeController.text,
            onChanged: (value) {
              setState(() {
                _typeController.text = value;
              });
            },
          ),
          const SizedBox(height: 10),
          BlocBuilder<GroupsBloc, GroupsState>(
            builder: (context, state) {
              if (state is GroupsLoadingState) {
                return const CircularProgressIndicator();
              } else if (state is GroupsSuccessState) {
                final groups = state.groups;
                final filteredGroups = groups.where((group) => group.id != '0').toList();

                filteredGroups.insert(
                  0,
                  GroupModel(
                    id: '0',
                    name: 'Sem grupo',
                    members: [],
                    owner: '',
                    description: '',
                  ),
                );

                return CustomSelectFormField(
                  hint: 'Associar a um grupo',
                  options: filteredGroups.map((e) => e.name).toList(),
                  selectedValue: _groupController.text,
                  onChanged: (value) {
                    setState(() {
                      _groupController.text = value;
                    });
                  },
                );
              } else {
                return const Text('Erro ao carregar grupos');
              }
            },
          ),
          const SizedBox(height: 10),
          CustomRadioFormField(
            hint: 'Selecione a categoria',
            options: Constants().categoryMap.keys.toList(),
            groupValue: _categoryController.text,
            onChanged: (value) {
              setState(() {
                _categoryController.text = value;
              });
            },
          ),
          const SizedBox(height: 10),
          CustomButton(
            width: 140,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final user = context.read<UserCubit>().state;
                final groupsState = context.read<GroupsBloc>().state;
                if (groupsState is GroupsSuccessState) {
                  final selectedGroup = groupsState.groups
                      .firstWhere(
                        (element) => element.name == _groupController.text,
                        orElse: () => GroupModel(
                          id: '0',
                          name: 'Sem grupo',
                          members: [],
                          owner: '',
                          description: '',
                        ),
                      )
                      .id;

                  context.read<FinanceBloc>().add(
                        FinanceCreateEvent(
                          userId: user.id,
                          title: _titleController.text,
                          amount: double.parse(_amountController.text.replaceAll(',', '.')),
                          groupId: selectedGroup,
                          date: DateTime.parse(_dateController.text),
                          category: Constants()
                              .categoryMap[_categoryController.text]!,
                          type: Constants().typeMap[_typeController.text]!,
                        ),
                      );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Erro: Grupos não carregados')),
                  );
                }
              }
            },
            text: 'Cadastrar',
          ),
        ],
      ),
    );
  }
}
