/* Flutter Imports */
import 'package:flutter/material.dart';

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
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 3,
          children: widget.options.map((option) {
            return RadioListTile(
              title: Text(
                option,
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              fillColor: WidgetStateProperty.all(Theme.of(context).colorScheme.secondary),
              value: option,
              groupValue: widget.groupValue,
              onChanged: (value) {
                setState(() {
                  widget.onChanged!(value as String);
                });
              },
            );
          }).toList(),
        )
      ],
    );
  }
}
