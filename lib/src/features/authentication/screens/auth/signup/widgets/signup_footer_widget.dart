import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/image_strings.dart';
import 'package:hobin_warehouse/src/constants/text_strings.dart';
import 'package:hobin_warehouse/src/features/authentication/screens/auth/signin/signin.dart';
import 'package:hobin_warehouse/src/repository/authentication_repository/authentication_repository.dart';

class SignUpFooterWidget extends StatelessWidget {
  const SignUpFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Hoặc",
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              AuthenticationRepository.instance.signinWithGoogle();
            },
            icon: const Image(
              image: AssetImage(tLogoGoogleImage),
              width: 20.0,
            ),
            label: Text(tSignInWithGG,
                style: Theme.of(context).textTheme.titleLarge),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SigninScreen()),
            );
          },
          child: Text.rich(
            TextSpan(
                text: tHaveAnAccount,
                style: Theme.of(context).textTheme.titleLarge,
                children: const [
                  TextSpan(
                    text: tLogin,
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
