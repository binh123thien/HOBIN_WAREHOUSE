import 'package:fluttertoast/fluttertoast.dart';

class ToastWidget {
  static void showToast(String text) => Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        fontSize: 17,
      );
}
