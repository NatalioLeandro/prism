/* Flutter Imports */
import 'package:flutter/material.dart';

/* Project Imports */
import 'package:prism/core/enums/alert_type.dart';
import 'package:prism/core/themes/palette.dart';

class MessageDialog extends StatefulWidget {
  final String title;
  final String message;
  final AlertType type;
  final VoidCallback? onConfirm;
  final VoidCallback? onDismiss;
  final VoidCallback? onRedirect;

  const MessageDialog({
    super.key,
    required this.title,
    required this.message,
    required this.type,
    this.onConfirm,
    this.onDismiss,
    this.onRedirect,
  });

  @override
  State<MessageDialog> createState() => _MessageDialogState();
}

class _MessageDialogState extends State<MessageDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    if (widget.onRedirect != null) {
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          widget.onRedirect!();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color getColor() {
    switch (widget.type) {
      case AlertType.success:
        return Palette.success;
      case AlertType.error:
        return Palette.error;
      case AlertType.warning:
        return Palette.warning;
      default:
        return Palette.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      titlePadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      title: Container(
        height: 80,
        padding: const EdgeInsets.all(5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: getColor().withOpacity(0.07),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        child: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: getColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80,
              alignment: Alignment.center,
              child: Text(
                widget.message,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            if (widget.onRedirect != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _controller.value,
                      valueColor: AlwaysStoppedAnimation(getColor()),
                      backgroundColor: getColor().withOpacity(0.1),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      actions: [
        if (widget.onConfirm != null)
          TextButton(
            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              overlayColor:
              WidgetStateProperty.all(getColor().withOpacity(0.1)),
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              widget.onConfirm!();
            },
            child: Text(
              'Confirmar',
              style: TextStyle(color: getColor()),
            ),
          ),
        if (widget.onDismiss != null)
          TextButton(
            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              overlayColor:
              WidgetStateProperty.all(getColor().withOpacity(0.1)),
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              widget.onDismiss!();
            },
            child: Text(
              'Cancelar',
              style: TextStyle(color: getColor()),
            ),
          ),
      ],
    );
  }
}
