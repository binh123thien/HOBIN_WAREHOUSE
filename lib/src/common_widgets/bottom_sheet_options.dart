import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/text_strings.dart';

import '../constants/sizes.dart';
import '../features/authentication/screens/auth/forget_password/forget_password_options/forget_password_btn_widget.dart';

class BottomSheetOptions extends StatefulWidget {
  final String textOneofTwo;
  final VoidCallback onTapGallery, onTapCamera;
  const BottomSheetOptions(
      {super.key,
      required this.textOneofTwo,
      required this.onTapGallery,
      required this.onTapCamera});

  @override
  State<BottomSheetOptions> createState() => _BottomSheetOptionsState();
}

class _BottomSheetOptionsState extends State<BottomSheetOptions> {
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
          "Chọn 1 trong 2 phương thức để đặt lại hình ảnh ${widget.textOneofTwo} của bạn",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 40.0),
        ForgetPasswordBtnWidget(
          btnIcon: Icons.collections_outlined,
          title: "Bộ sưu tập",
          subTittle: "Chọn hình ảnh từ thiết bị",
          onTap: widget.onTapGallery,
        ),
        const SizedBox(height: 30.0),
        ForgetPasswordBtnWidget(
            btnIcon: Icons.photo_camera_outlined,
            title: "Máy ảnh",
            subTittle: "Chụp hình qua thiết bị",
            onTap: widget.onTapCamera),
      ]),
    );
  }
}
