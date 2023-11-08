import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/common_widgets/fontSize/font_size.dart';

import '../constants/color.dart';

class ExitConfirmationDialog extends StatelessWidget {
  const ExitConfirmationDialog({
    Key? key,
    required this.message,
    required this.onConfirmed,
    required this.dialogChild,
    required this.phanBietNhapXuat,
  }) : super(key: key);

  final int phanBietNhapXuat;
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
            title: Text(
              'Xác nhận',
              style: TextStyle(
                color: phanBietNhapXuat == 0 ? mainColor : blueColor,
                fontSize: Font.sizes(context)[1],
                fontWeight: FontWeight.w800,
              ),
            ),
            content: Text(
              message,
              style: TextStyle(fontSize: Font.sizes(context)[1]),
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
                child: Text(
                  'CÓ',
                  style: TextStyle(
                      color: phanBietNhapXuat == 0 ? mainColor : blueColor,
                      fontWeight: FontWeight.w800),
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
