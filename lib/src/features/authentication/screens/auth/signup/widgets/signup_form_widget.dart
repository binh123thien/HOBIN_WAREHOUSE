import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/sizes.dart';
import 'package:hobin_warehouse/src/constants/text_strings.dart';
import 'package:hobin_warehouse/src/features/authentication/controllers/signup_controller.dart';
import 'package:hobin_warehouse/src/features/authentication/screens/auth/verify_email/check_email_verify.dart';
import 'package:hobin_warehouse/src/utils/validate/validate.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({super.key});

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget>
    with InputValidationMixin {
  bool _showpass = true;
  bool _showpassconfirm = true;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    final formKey = GlobalKey<FormState>();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email
            TextFormField(
              controller: controller.email,
              decoration: const InputDecoration(
                errorStyle: TextStyle(fontSize: 15),
                label: Text(tEmail),
                prefixIcon: Icon(Icons.mail_outline),
              ),
              validator: (value) {
                return emailCheckForm(value!);
              },
            ),
            const SizedBox(height: tDefaultSize - 10),

            //Password
            TextFormField(
              obscureText: _showpass,
              controller: controller.password,
              decoration: InputDecoration(
                errorStyle: const TextStyle(fontSize: 15),
                label: const Text(tPassword),
                prefixIcon: const Icon(Icons.lock_outlined),
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
            const SizedBox(height: tDefaultSize - 10),

            //Confirm Pass
            TextFormField(
              obscureText: _showpassconfirm,
              controller: controller.confirmpass,
              decoration: InputDecoration(
                errorStyle: const TextStyle(fontSize: 15),
                label: const Text(tConfirmPassword),
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _showpassconfirm = !_showpassconfirm;
                    });
                  },
                  icon: _showpassconfirm
                      ? const Icon(Icons.visibility_outlined)
                      : const Icon(Icons.visibility_off_outlined),
                ),
              ),
              validator: (value) {
                return confirmPassCheckForm(value!);
              },
            ),

            const SizedBox(height: tDefaultSize - 10),

            //Sign Up
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Dang ky bang email
                    SignUpController.instance.registerUser(
                        controller.email.text.trim(),
                        controller.password.text.trim());
                    Get.to(() => const CheckEmailScreen());
                  }
                },
                child: Text(
                  tSignup.toUpperCase(),
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
