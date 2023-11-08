import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/common_widgets/fontSize/font_size.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/account/update_profile_screen.dart';
import 'package:hobin_warehouse/src/repository/authentication_repository/authentication_repository.dart';
import '../../../../common_widgets/dialog/dialog.dart';

// ignore: must_be_immutable
class AccountScreen extends StatefulWidget {
  AccountScreen({super.key, required this.userAccountUpdate});
  Map userAccountUpdate;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    void logout(BuildContext context) {
      AuthenticationRepository.instance.logout();
      Navigator.of(context).pop();
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
          color: Colors.black,
        ),
        backgroundColor: whiteColor,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          ListTile(
            leading: widget.userAccountUpdate['PhotoURL'].isEmpty
                ? const Icon(
                    Icons.account_circle,
                    size: 45,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      height: size.width * 0.12,
                      width: size.width * 0.12, //40,
                      imageUrl: widget.userAccountUpdate['PhotoURL'],
                      fit: BoxFit.fill,
                    ),
                  ),
            title: Text(
              widget.userAccountUpdate['Name'],
              style: TextStyle(fontSize: Font.sizes(context)[2]),
              textAlign: TextAlign.start,
            ),
            subtitle: Text(
              widget.userAccountUpdate['Email'],
              style: TextStyle(fontSize: Font.sizes(context)[1]),
              textAlign: TextAlign.start,
            ),
          ),
          const Divider(),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateProfileScreen(
                      userData: widget.userAccountUpdate,
                      photoFb: widget.userAccountUpdate['PhotoURL']),
                ),
              ).then(
                (newvalue) {
                  print('vao then');
                  print(newvalue);
                  if (newvalue == true) {
                    print('nhay vao true');
                  } else if (newvalue is Map) {
                    print('vao setState');
                    setState(() {
                      widget.userAccountUpdate = newvalue;
                    });
                  } else {
                    print('nhay vao false');
                  }
                },
              );
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: size.height * 0.063, //50
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Image(
                      image: const AssetImage(managerIcon),
                      width: size.width * 0.063, //25
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Quản lý tài khoản",
                      style: TextStyle(fontSize: Font.sizes(context)[2]),
                    )
                  ],
                ),
              ),
            ),
          ),

          // ==================Logout=======================//
          InkWell(
            onTap: () {
              MyDialog.showAlertDialog(
                context,
                "Đăng xuất",
                "Bạn muốn đăng xuất tài khoản?",
                0,
                () => logout(context),
              );
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: size.height * 0.063, //50
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Image(
                      image: const AssetImage(logoutIcon),
                      width: size.width * 0.063, //25,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Đăng xuất",
                      style: TextStyle(fontSize: Font.sizes(context)[2]),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
