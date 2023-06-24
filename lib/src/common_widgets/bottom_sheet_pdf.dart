import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/text_strings.dart';

import '../constants/sizes.dart';
import '../features/authentication/screens/auth/forget_password/forget_password_options/forget_password_btn_widget.dart';

class BottomSheetPDF extends StatefulWidget {
  final String textOneofTwo;
  final VoidCallback onTapGallery, onTapCamera;
  const BottomSheetPDF(
      {super.key,
      required this.textOneofTwo,
      required this.onTapGallery,
      required this.onTapCamera});

  @override
  State<BottomSheetPDF> createState() => _BottomSheetPDFState();
}

class _BottomSheetPDFState extends State<BottomSheetPDF> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding: const EdgeInsets.all(tDefaultSize),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          tMakeSelection,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          "Chọn 1 trong 2 phương thức để ${widget.textOneofTwo} của bạn",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 40.0),
        ForgetPasswordBtnWidget(
          btnIcon: Icons.picture_as_pdf_outlined,
          title: "Xem hóa đơn dạng PDF",
          subTittle: "Chọn hình thức in file",
          onTap: widget.onTapGallery,
        ),
        const SizedBox(height: 30.0),
        ForgetPasswordBtnWidget(
            btnIcon: Icons.ios_share_outlined,
            title: "Chia sẻ tệp PDF",
            subTittle: "Chọn hình thức chia sẻ file",
            onTap: widget.onTapCamera),
      ]),
    );
  }
}
