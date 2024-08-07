/* Flutter Imports */
import 'package:flutter/material.dart';

/* Project Imports */
import 'package:prism/core/themes/palette.dart';

class CustomRadioFormField extends StatefulWidget {
  final String hint;
  final List<String> options;
  final String? groupValue;
  final ValueChanged<String>? onChanged;

  const CustomRadioFormField({
    super.key,
    required this.hint,
    required this.options,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  State<CustomRadioFormField> createState() => _CustomRadioFormFieldState();
}

class _CustomRadioFormFieldState extends State<CustomRadioFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.hint,
          style: const TextStyle(
            fontSize: 14,
            color: Palette.white,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.options.map((option) {
            return RadioListTile(
              title: Text(
                option,
                style: const TextStyle(
                  fontSize: 14,
                  color: Palette.white,
                ),
              ),
              value: option,
              groupValue: widget.groupValue,
              onChanged: (value) {
                setState(() {
                  widget.onChanged!(value as String);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
