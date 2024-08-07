/* Flutter Imports */
import 'package:flutter/material.dart';

/* Project Imports */
import 'package:prism/core/themes/palette.dart';

class CustomDropdownButtonFormField<EnumType extends Enum>
    extends StatelessWidget {
  final String labelText;
  final EnumType? selectedValue;
  final List<EnumType> enumValues;
  final Function(EnumType?) onChanged;
  final String? Function(EnumType?)? validator;

  const CustomDropdownButtonFormField({
    super.key,
    required this.labelText,
    required this.selectedValue,
    required this.enumValues,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<EnumType>(
      decoration: InputDecoration(
        labelStyle: const TextStyle(
          fontSize: 14,
          color: Palette.white,
        ),
        labelText: labelText,
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      value: selectedValue,
      items: enumValues.map((value) {
        return DropdownMenuItem<EnumType>(
          value: value,
          child: Text(
            value.toString().split('.').last,
            style: const TextStyle(
              fontSize: 14,
              color: Palette.primary,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
