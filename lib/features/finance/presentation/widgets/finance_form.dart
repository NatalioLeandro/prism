/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/core/common/cubit/user/user_cubit.dart';
import 'package:prism/core/common/widgets/date_field.dart';
import 'package:prism/core/common/widgets/form_field.dart';
import 'package:prism/core/common/widgets/button.dart';
import 'package:prism/core/common/widgets/select_field.dart';
import 'package:prism/core/enums/expense_category.dart';
import 'package:prism/features/finance/presentation/bloc/finance_bloc.dart';

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
  final _dateController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _categoryController.dispose();
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
          const SizedBox(height: 15),
          CustomFormField(
            hint: 'Digite o valor',
            label: 'Valor',
            icon: Icons.monetization_on_outlined,
            controller: _amountController,
          ),
          const SizedBox(height: 15),
          DateFormField(
            hint: 'Selecione a data',
            controller: _dateController,
          ),
          const SizedBox(height: 15),
          CustomRadioFormField(
            hint: 'Selecione a categoria',
            options: ExpenseCategory.values.map((e) => e.name).toList(),
            groupValue: _categoryController.text,
            onChanged: (value) {
              setState(() {
                _categoryController.text = value;
              });
            },
          ),
          const SizedBox(height: 15),
          CustomButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final user = context.read<UserCubit>().state;
                context.read<FinanceBloc>().add(
                      FinanceCreateEvent(
                        userId: user.id,
                        title: _titleController.text,
                        amount: double.parse(_amountController.text),
                        date: DateTime.parse(_dateController.text),
                        category: ExpenseCategory.values.firstWhere(
                          (e) =>
                              e.name ==
                              _categoryController.text
                                  .toLowerCase()
                                  .replaceAll(' ', '_')
                        ),
                      ),
                    );
              }
            },
            text: 'Cadastrar',
          ),
        ],
      ),
    );
  }
}
