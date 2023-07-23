import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

class MyDialog {
  static void showAlertDialog(BuildContext context, String textTitle,
      String textContent, VoidCallback onYES) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: Text(
          textTitle,
          style: const TextStyle(
            color: mainColor,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          textContent,
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pop(false); // Đóng dialog và trả về giá trị false
            },
            child: const Text(
              'KHÔNG',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              onYES();
            },
            child: const Text(
              'CÓ',
              style: TextStyle(color: mainColor, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  static void showAlertDialogOneBtn(
      BuildContext context, String textTitle, String textContent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: Text(
          textTitle,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.9, // set custom width
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            textContent,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        contentPadding: EdgeInsets.zero, // remove default content padding
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pop(false); // Đóng dialog và trả về giá trị false
            },
            child: const Text(
              'QUAY LẠI',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
