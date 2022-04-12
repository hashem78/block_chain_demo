import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnterBlockIdDialog extends HookWidget {
  const EnterBlockIdDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    return AlertDialog(
      title: Text('Enter blockId'),
      content: SizedBox(
        width: 0.3.sw,
        child: TextField(
          controller: controller,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, controller.text);
          },
          child: Text('OK'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
