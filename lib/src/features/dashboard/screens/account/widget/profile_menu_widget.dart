import 'package:flutter/material.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    required this.title,
    required this.imageicon,
    required this.onPress,
    this.textColor,
    super.key,
  });

  final String title;
  final String imageicon;
  final VoidCallback onPress;
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
          onTap: onPress,
          leading: SizedBox(
            width: 40,
            height: 40,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(100),
            //   color: Colors.grey.withOpacity(0.5),
            // ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ImageIcon(
                AssetImage(imageicon),
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
