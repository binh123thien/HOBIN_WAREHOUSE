import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/sizes.dart';
import 'package:hobin_warehouse/src/constants/text_strings.dart';
import 'package:hobin_warehouse/src/features/authentication/controllers/signin_controller.dart';
import 'package:hobin_warehouse/src/features/authentication/screens/auth/forget_password/forget_password_options/forget_password_model_bottom_sheet.dart';
import 'package:hobin_warehouse/src/utils/validate/validate.dart';

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
    final _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: tFormHeight),
        child: Column(
          children: [
            // ============= Form ====================================
            // Email
            TextFormField(
              controller: controller.email,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mail_outline),
                  labelText: tEmail,
                  hintText: tEmail,
                  errorStyle: TextStyle(fontSize: 15),
                  border: OutlineInputBorder()),
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
                errorStyle: const TextStyle(fontSize: 15),
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
                  child: const Text(tForgorPassword,
                      style: TextStyle(color: mainColor))),
            ),
            // ===================== end btn =========================

            // ===================== btn login =======================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      SignInController.instance.signinWithEmailAndPassword(
                          controller.email.text.trim(),
                          controller.password.text.trim());
                    }
                  },
                  child: Text(
                    tLogin.toUpperCase(),
                    style: const TextStyle(fontSize: 22),
                  )),
            ),
            // ===================== end btn login =====================
          ],
        ),
      ),
    );
  }
}
