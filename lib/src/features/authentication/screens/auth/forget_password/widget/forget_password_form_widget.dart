// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/text_strings.dart';
import 'package:hobin_warehouse/src/features/authentication/controllers/forget_pass_controller.dart';
import 'package:hobin_warehouse/src/features/authentication/screens/auth/forget_password/forget_password_mail/check_reset_password.dart';

class ForgetPassFormWidget extends StatelessWidget {
  const ForgetPassFormWidget({
    super.key,
    required this.tHint,
    required this.tLabel,
    required this.tPrefixIcon,
  });

  final String tLabel, tHint;
  final dynamic tPrefixIcon;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPassController());
    final _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: controller.password,
            decoration: InputDecoration(
              label: Text(tLabel),
              hintText: tHint,
              prefixIcon: tPrefixIcon,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ForgetPassController.instance
                      .resetPassword(controller.password.text.trim());
                  Get.to(() => const CheckResetPass());
                }
              },
              child: Text(tContinue.toUpperCase(),
                  style: const TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}
