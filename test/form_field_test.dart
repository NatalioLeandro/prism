import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism/core/common/widgets/form_field.dart';

void main() {
  group('CustomFormField', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('should display hint and label text', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomFormField(
              hint: 'Enter text',
              label: 'Label text',
              icon: Icons.person,
              controller: controller,
            ),
          ),
        ),
      );

      // Act & Assert
      expect(find.text('Enter text'), findsOneWidget);
      expect(find.text('Label text'), findsOneWidget);
    });

    testWidgets('should display validation error message when field is empty', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: CustomFormField(
                hint: 'Enter text',
                label: 'Label text',
                icon: Icons.person,
                controller: controller,
              ),
            ),
          ),
        ),
      );

      // Act
      final formState = tester.state<FormState>(find.byType(Form));
      formState.validate();
      await tester.pump();

      // Assert
      expect(find.text('Campo obrigatório'), findsOneWidget);
    });

    testWidgets('should not display validation error message when field is filled', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: CustomFormField(
                hint: 'Enter text',
                label: 'Label text',
                icon: Icons.person,
                controller: controller,
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField), 'Valid text');
      final formState = tester.state<FormState>(find.byType(Form));
      formState.validate();
      await tester.pump();

      // Assert
      expect(find.text('Campo obrigatório'), findsNothing);
    });
  });
}
