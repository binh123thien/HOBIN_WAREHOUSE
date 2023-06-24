import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/text_strings.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/account/account_screen.dart';

import '../../../../constants/image_strings.dart';
import 'widget/card_dashboard.dart';
import 'widget/expense_graph.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        title: const Text(tHomeTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        backgroundColor: mainColor,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage(tBackGround1), // where is this variable defined?
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountScreen(),
                ),
              );
            },
            icon: const Icon(Icons.account_circle),
            iconSize: 40,
          )
        ],
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(children: [
            CardDashboard(),
            SizedBox(height: 10),
            ExpenseTrack(),
            SizedBox(height: 10),
          ]),
        ),
      ),
    );
  }
}
