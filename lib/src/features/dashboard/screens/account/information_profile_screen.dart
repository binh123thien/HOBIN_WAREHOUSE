import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/constants/sizes.dart';

import '../../../../constants/image_strings.dart';

import '../../../authentication/models/user_models.dart';

class InformationProfileScreen extends StatefulWidget {
  final UserModel user;
  const InformationProfileScreen({super.key, required this.user});

  @override
  State<InformationProfileScreen> createState() =>
      _InformationProfileScreenState();
}

class _InformationProfileScreenState extends State<InformationProfileScreen> {
  late UserModel userData;
  @override
  void initState() {
    // Gán giá trị của widget.user vào state để sử dụng: cập nhập thuộc tính
    super.initState();
    userData = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            backIcon,
            height: 20,
            color: whiteColor,
          ),
        ),
        backgroundColor: backGroundColor,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage(tBackGround1), // where is this variable defined?
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: const Text(
          "Thông tin tài khoản",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w900, fontSize: 21),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              //avatar
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    imageUrl: (userData.photoURL.isNotEmpty)
                        ? userData.photoURL
                        : tDefaultAvatar,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              //======================= end avatar ===========================================
              const SizedBox(height: 10),
              Text(
                userData.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                userData.email,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 20),
              const Divider(),
              InformationUserWidget(
                textColor: Colors.black,
                title: userData.email,
                imageicon: Icons.mail_outline,
              ),
              InformationUserWidget(
                textColor: Colors.black,
                title:
                    userData.name != '' ? userData.name : "Chưa có họ và tên",
                imageicon: Icons.badge_outlined,
              ),
              InformationUserWidget(
                textColor: Colors.black,
                title: userData.phone == ''
                    ? "Chưa có số điện thoại"
                    : userData.phone,
                imageicon: Icons.phone_iphone_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InformationUserWidget extends StatelessWidget {
  const InformationUserWidget({
    super.key,
    required this.title,
    required this.imageicon,
    required this.textColor,
  });

  final String title;
  final IconData imageicon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Container(
        // color: Colors.amberAccent,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.withOpacity(0.6)),
        child: ListTile(
          onTap: () {},
          leading: SizedBox(
            width: 40,
            height: 40,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(100),
            //   color: Colors.grey.withOpacity(0.5),
            // ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                imageicon,
                color: Colors.black,
              ),
            ),
          ),
          title: Text(
            title,
            style:
                Theme.of(context).textTheme.bodySmall?.apply(color: textColor),
          ),
        ),
      ),
    );
  }
}
