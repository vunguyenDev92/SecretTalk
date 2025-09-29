import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = 'OK',
    this.cancelText = 'Cancel',
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            if (onConfirm != null) onConfirm!();
          },
          child: Text(confirmText),
        ),
      ],
    );
  }
}
