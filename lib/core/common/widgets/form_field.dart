/* Flutter Imports */
import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {

  final String hint;
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool obscure;
  final String? Function(String?)? validator;
  final List<String> autofillHints;

  const CustomFormField({
    super.key,
    required this.hint,
    required this.label,
    required this.icon,
    required this.controller,
    this.obscure = false,
    this.validator,
    this.autofillHints = const [],
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      autofillHints: autofillHints,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(15),
        hintText: hint,
        labelText: label,
        suffixIcon: Icon(icon),
      ),
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'Campo obrigatório';
        }
        return null;
      },
    );
  }
}

