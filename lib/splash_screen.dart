import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/image_strings.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: whiteColor,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(splashcreenicon),
              height: 120,
            ),
            SizedBox(height: 10),
            Text(
              "HOBIN",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700, color: mainColor),
            ),
            Text(
              "WAREHOUSE",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
      ),
    );
  }
}
