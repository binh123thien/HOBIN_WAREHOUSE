import 'package:flutter/material.dart';

import '../constants/color.dart';

class ExitConfirmationDialog extends StatelessWidget {
  const ExitConfirmationDialog({
    Key? key,
    required this.message,
    required this.onConfirmed,
    required this.dialogChild,
  }) : super(key: key);

  final String message;
  final VoidCallback onConfirmed;
  final Widget dialogChild;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: const Text(
              'Xác nhận',
              style: TextStyle(
                color: mainColor,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            content: Text(
              message,
              style: const TextStyle(fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  'KHÔNG',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: onConfirmed,
                child: const Text(
                  'CÓ',
                  style:
                      TextStyle(color: mainColor, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        );
        return shouldExit;
      },
      child: dialogChild,
    );
  }
}
