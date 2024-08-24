/* Flutter Imports */
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const DateFormField({
    super.key,
    required this.hint,
    required this.controller,
    this.validator,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final DateTime finalDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        DateTime.now().hour,
        DateTime.now().minute,
      );
      controller.text = DateFormat('yyyy-MM-dd HH:mm').format(finalDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(context),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(15),
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        suffixIcon: IconButton(
          onPressed: () => _selectDate(context),
          icon: const Icon(Icons.calendar_today),
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      style: TextStyle(
        fontSize: 14,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Campo obrigatório';
            }
            return null;
          },
    );
  }
}
