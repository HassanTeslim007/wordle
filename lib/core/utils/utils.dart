import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

SizedBox ySpace(height) {
  return SizedBox(
    height: height.toDouble(),
  );
}

// Used to give horizontal Spaces
SizedBox xSpace(width) {
  return SizedBox(
    width: width.toDouble(),
  );
}

extension StringExtension on String {
  bool isDigit() {
    try {
      double.parse(this);
      return true;
    } catch (e) {
      return false;
    }
  }
}

Future<void> showAlertDialog(BuildContext context,
    {String? title,
    required Widget body,
    bool withButton = true,
    bool withCancel = true,
    Widget? button,
    String? cancelTitle,
    String? okTitle,
    VoidCallback? okPressed}) async {
   await showPlatformDialog(
    context: context,
    androidBarrierDismissible: false,
    builder: (_) => BasicDialogAlert(
      title: Text(
        title ?? "Confirmation",
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: body,
      actions: <Widget>[
        if (withCancel)
          BasicDialogAction(
            title: Text(
              cancelTitle ?? 'Cancel',
              textScaleFactor: 1.0,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        BasicDialogAction(
          title: Text(
            okTitle ?? 'ok',
            textScaleFactor: 1.0,
            style: const TextStyle(
              color: Colors.green,
            ),
          ),
          onPressed: okPressed ?? () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}
