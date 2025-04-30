import 'package:flutter/material.dart';
import '../../shared/widgets/custom_dialog.dart';

class DialogUtil {
  static Future<bool> showExitDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => CustomDialog(
            title: "Exit App",
            message: "Are you sure you want to exit?",
            confirmText: "Yes",
            cancelText: "No",
            confirmColor: Theme.of(context).indicatorColor,
            cancelColor: Theme.of(context).primaryColorDark,
            onConfirm: () {
              Navigator.of(context).pop(true);
            },
            onCancel: () {
              Navigator.of(context).pop(false);
            },
          ),
        ) ??
        false;
  }
}
