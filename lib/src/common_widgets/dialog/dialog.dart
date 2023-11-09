import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';

import '../fontSize/font_size.dart';

class MyDialog {
  static void showAlertDialog(BuildContext context, String textTitle,
      String textContent, int phanBietNhapXuat, VoidCallback onYES) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          textTitle,
          style: TextStyle(
            color: phanBietNhapXuat == 0 ? mainColor : blueColor,
            fontSize: Font.sizes(context)[1],
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Container(
          width: MediaQuery.of(context).size.width, // set custom width
          child: Text(
            textContent,
            style: TextStyle(fontSize: Font.sizes(context)[1]),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pop(false); // Đóng dialog và trả về giá trị false
            },
            child: Text(
              'KHÔNG',
              style: TextStyle(
                  color: Colors.black, fontSize: Font.sizes(context)[1]),
            ),
          ),
          TextButton(
            onPressed: () {
              onYES();
            },
            child: Text(
              'CÓ',
              style: TextStyle(
                  color: phanBietNhapXuat == 0 ? mainColor : blueColor,
                  fontSize: Font.sizes(context)[1],
                  fontWeight: FontWeight.w800),
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
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          textTitle,
          style: TextStyle(
            color: Colors.red,
            fontSize: Font.sizes(context)[1],
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Container(
          width: MediaQuery.of(context).size.width, // set custom width
          padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 10),
          child: Text(
            textContent,
            style: TextStyle(fontSize: Font.sizes(context)[1]),
          ),
        ),
        contentPadding: EdgeInsets.zero, // remove default content padding
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pop(false); // Đóng dialog và trả về giá trị false
            },
            child: Text(
              'QUAY LẠI',
              style: TextStyle(
                  color: Colors.black, fontSize: Font.sizes(context)[1]),
            ),
          ),
        ],
      ),
    );
  }

  static void showAlertDialogTextfield(
      BuildContext context,
      String textTitle,
      String textContent,
      VoidCallback onYES,
      TextEditingController controller) {
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          textTitle,
          style: const TextStyle(
            color: mainColor,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 100, // set custom width
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Form(
            key: formKey,
            child: TextFormField(
                controller: controller,
                validator: (value) {
                  return oneCharacter(value!);
                }),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pop(false); // Đóng dialog và trả về giá trị false
            },
            child: const Text(
              'Hủy',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                onYES();
              }
            },
            child: const Text(
              'Thêm',
              style: TextStyle(color: mainColor, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

String? oneCharacter(String s) {
  if (s.isNotEmpty) {
    return null;
  } else {
    return "Không được để trống";
  }
}
