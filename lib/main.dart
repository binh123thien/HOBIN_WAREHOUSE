import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/firebase_api.dart';
import 'package:hobin_warehouse/firebase_options.dart';
import 'package:hobin_warehouse/splash_screen.dart';
import 'package:hobin_warehouse/src/repository/authentication_repository/authentication_repository.dart';
import 'package:hobin_warehouse/src/utils/theme/theme.dart';

Future<void> main() async {
  // Future.delayed(const Duration(seconds: 2), () {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthenticationRepository()));
  // });
  await FirebaseAPI().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
