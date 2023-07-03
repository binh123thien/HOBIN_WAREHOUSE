import 'package:get/get.dart';
import 'package:hobin_warehouse/src/features/authentication/controllers/signup_controller.dart';
import 'package:intl/intl.dart';

final controller = Get.put(SignUpController());

class InputValidationMixin {
  // bool isPasswordValid(String password) {
  //   final passwordRegExp = RegExp(r'^(?=.*?[A-Z][a-z]).{6,}$');
  //   return passwordRegExp.hasMatch(password);
  // }

  bool isEmailValid(String email) {
    final emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(email);
  }

  emailCheckForm(String email) {
    if (email.isEmpty) {
      return "Không được để trống Email";
    } else if (!isEmailValid(email)) {
      return "Nhập đúng định dạng Email";
    } else {
      return null;
    }
  }

  passwordCheckForm(String password) {
    if (password.isEmpty) {
      return "Không được để trống Password";
    }
    // else if (!isPasswordValid(password)) {
    //   return "Mật khẩu bắt đầu bằng chữ cái in hoa \nvà tối thiểu 6 ký tự";
    // }
    else {
      return null;
    }
  }

  confirmPassCheckForm(String confirmpass) {
    if (confirmpass.isEmpty) {
      return "Không được để trống Password";
    } else if (confirmpass != controller.password.text.trim()) {
      return "Mật khẩu không khớp!";
    } else {
      return null;
    }
  }

  oneCharacter(String string) {
    if (string.isNotEmpty) {
      return null;
    } else {
      return "Không được để trống";
    }
  }
}

String formatNumber(String value) {
  final number = int.tryParse(value);
  if (number == null) {
    return '';
  }
  final formatter = NumberFormat(",###");
  return formatter.format(number);
}

//không cho nhập số 0 hoặc rỗng
String? nonZeroInput(String? value) {
  if (value == null || value.isEmpty) {
    return 'Vui lòng nhập số khác 0';
  } else if (value.startsWith('0')) {
    return 'Số đầu tiên không thể là 0';
  }
  return null;
}
