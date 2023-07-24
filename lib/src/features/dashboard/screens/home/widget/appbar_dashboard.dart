import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/color.dart';
import '../../../controllers/account/profile_controller.dart';
import '../../account/account_screen.dart';

class AppBarDashBoard extends StatefulWidget {
  const AppBarDashBoard({super.key});

  @override
  State<AppBarDashBoard> createState() => _AppBarDashBoardState();
}

class _AppBarDashBoardState extends State<AppBarDashBoard> {
  final controllerProfile = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AccountScreen(),
          ),
        );
      },
      child: StreamBuilder<QuerySnapshot>(
        stream: controllerProfile.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Không có dữ liệu"));
          } else {
            // Hiển thị thông tin người dùng
            var userAccountUpdate = snapshot.data!.docs[0].data();
            print(userAccountUpdate);
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Row(
                children: [
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: (userAccountUpdate is Map &&
                              userAccountUpdate['PhotoURL'].isNotEmpty)
                          ? CachedNetworkImage(
                              imageUrl: userAccountUpdate['PhotoURL'],
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : const Icon(
                              Icons.account_circle,
                              color: mainColor,
                              size: 45,
                            ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, ${userAccountUpdate is Map ? userAccountUpdate["Name"] ?? '' : ''}!",
                        style: const TextStyle(fontSize: 13),
                      ),
                      Text(
                          userAccountUpdate is Map
                              ? userAccountUpdate['Email'] ??
                                  userAccountUpdate['Email']
                              : '',
                          style: const TextStyle(fontSize: 15)),
                    ],
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
