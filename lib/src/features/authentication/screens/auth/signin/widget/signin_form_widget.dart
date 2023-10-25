import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/sizes.dart';
import 'package:hobin_warehouse/src/constants/text_strings.dart';
import 'package:hobin_warehouse/src/features/authentication/controllers/signin_controller.dart';
import 'package:hobin_warehouse/src/features/authentication/screens/auth/forget_password/forget_password_options/forget_password_model_bottom_sheet.dart';
import 'package:hobin_warehouse/src/utils/validate/validate.dart';

import '../../../../../../common_widgets/fontSize/font_size.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> with InputValidationMixin {
  bool _showpass = true;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());
    final formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: tFormHeight),
        child: Column(
          children: [
            // ============= Form ====================================
            // Email
            TextFormField(
              controller: controller.email,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.mail_outline),
                  labelText: tEmail,
                  hintText: tEmail,
                  errorStyle: TextStyle(fontSize: Font.sizes(context)[1]),
                  border: const OutlineInputBorder()),
              validator: (value) {
                return emailCheckForm(value!);
              },
            ),
            const SizedBox(height: tFormHeight - 10),

            //Password
            TextFormField(
              obscureText: _showpass,
              controller: controller.password,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outlined),
                labelText: tPassword,
                hintText: tPassword,
                errorStyle: TextStyle(fontSize: Font.sizes(context)[1]),
                // errorText: tErrorPassword,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _showpass = !_showpass;
                    });
                  },
                  icon: _showpass
                      ? const Icon(Icons.visibility_outlined)
                      : const Icon(Icons.visibility_off_outlined),
                ),
              ),
              validator: (value) {
                return passwordCheckForm(value!);
              },
            ),
            // ================= end Form ================================

            //================== btn Forgot password ======================
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    ForgetPasswordScreen.buildShowModalBottomSheet(context);
                  },
                  child: Text(tForgorPassword,
                      style: TextStyle(
                          fontSize: Font.sizes(context)[1], color: mainColor))),
            ),
            // ===================== end btn =========================

            // ===================== btn login =======================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      SignInController.instance.signinWithEmailAndPassword(
                          controller.email.text.trim(),
                          controller.password.text.trim());
                    }
                  },
                  child: Text(
                    tLogin.toUpperCase(),
                    style: TextStyle(fontSize: Font.sizes(context)[4]),
                  )),
            ),
            // ===================== end btn login =====================
          ],
        ),
      ),
    );
  }
}
