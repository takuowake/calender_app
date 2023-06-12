import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showEditCanselConfirmation(BuildContext context) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
            // CupertinoActionSheetをポップします。
            Navigator.of(context).pop();
          },
          isDestructiveAction: true,
          child: const Text('編集を破棄', style: TextStyle(color: Colors.blue)),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text('キャンセル'),
        onPressed: () {
          Navigator.pop(context, 'Cancel');
        },
      ),
    ),
  );
}