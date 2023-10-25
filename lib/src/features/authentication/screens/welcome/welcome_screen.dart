import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/image_strings.dart';
import 'package:hobin_warehouse/src/constants/text_strings.dart';
import 'package:hobin_warehouse/src/constants/sizes.dart';
import 'package:hobin_warehouse/src/features/authentication/screens/auth/signin/signin.dart';
import 'package:hobin_warehouse/src/features/authentication/screens/auth/signup/signup.dart';

import '../../../../common_widgets/fontSize/font_size.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(
                image: const AssetImage(tWelcomeScreenImage),
                height: height * 0.6,
              ),
              Column(
                children: [
                  Text(
                    tWelcomeTitle,
                    style: TextStyle(fontSize: Font.sizes(context)[2]),
                  ),
                  Text(
                    tWelcomeSubTitle,
                    style: TextStyle(fontSize: Font.sizes(context)[2]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SigninScreen()),
                            );
                          },
                          child: Text(
                            tLogin.toUpperCase(),
                            style: TextStyle(fontSize: Font.sizes(context)[4]),
                          ))),
                  const SizedBox(width: 10),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()),
                            );
                          },
                          child: Text(tSignup.toUpperCase(),
                              style: TextStyle(
                                  fontSize: Font.sizes(context)[4])))),
                ],
              )
            ],
          )),
    );
  }
}
