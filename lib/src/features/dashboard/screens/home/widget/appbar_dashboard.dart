import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../constants/color.dart';
import '../../../../authentication/models/user_models.dart';
import '../../account/account_screen.dart';

class AppBarDashBoard extends StatelessWidget {
  const AppBarDashBoard({
    super.key,
    required this.userAccountUpdate,
  });

  final UserModel userAccountUpdate;

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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Row(
            children: [
              SizedBox(
                width: 45,
                height: 45,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: (userAccountUpdate.photoURL.isNotEmpty)
                      ? CachedNetworkImage(
                          imageUrl: userAccountUpdate.photoURL,
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
                    "Hi, ${userAccountUpdate.name}!",
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(userAccountUpdate.email,
                      style: const TextStyle(fontSize: 15)),
                ],
              )
            ],
          ),
        ));
  }
}
