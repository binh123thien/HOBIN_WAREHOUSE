import 'package:flutter/material.dart';

import '../../../../../constants/color.dart';

class FormUpdateProfile extends StatefulWidget {
  const FormUpdateProfile({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.icon,
    required this.enableText,
    required this.controllerValue,
    this.textInputType,
  }) : super(key: key);

  final String labelText, hintText;
  final Icon icon;
  final bool enableText;
  final TextEditingController controllerValue;
  final TextInputType? textInputType;

  @override
  _FormUpdateProfileState createState() => _FormUpdateProfileState();
}

class _FormUpdateProfileState extends State<FormUpdateProfile> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // set giá trị ban đầu của TextField
    _controller = widget.controllerValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: TextFormField(
        controller: _controller,
        enabled: widget.enableText,
        keyboardType: widget.textInputType,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: mainColor),
                borderRadius: BorderRadius.circular(100)),
            prefixIcon: widget.icon,
            labelText: widget.labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: widget.hintText,
            hintStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            errorStyle: const TextStyle(fontSize: 15),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(100))),
      ),
    );
  }
}
