import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/image_strings.dart';
import 'package:hobin_warehouse/src/constants/sizes.dart';
import 'package:hobin_warehouse/src/constants/text_strings.dart';
import 'package:hobin_warehouse/src/features/authentication/screens/auth/signup/signup.dart';
import 'package:hobin_warehouse/src/repository/authentication_repository/authentication_repository.dart';

class SigninFooterWidget extends StatelessWidget {
  const SigninFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Hoặc', style: TextStyle(fontSize: 18)),
        const SizedBox(height: tFormHeight - 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Image(
              image: AssetImage(tLogoGoogleImage),
              width: 20.0,
            ),
            onPressed: () {
              AuthenticationRepository.instance.signinWithGoogle();
            },
            label: Text(tSignInWithGG,
                style: Theme.of(context).textTheme.titleLarge),
          ),
        ),
        const SizedBox(height: tFormHeight - 10),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()),
            );
          },
          child: Text.rich(
            TextSpan(
                text: tDonHaveAnAccount,
                style: Theme.of(context).textTheme.titleLarge,
                children: const [
                  TextSpan(
                    text: tSignup,
                    style: TextStyle(
                        color: mainColor, fontWeight: FontWeight.w800),
                  ),
                ]),
          ),
        )
      ],
    );
  }
}
