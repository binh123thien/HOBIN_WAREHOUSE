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

  locationNameCheckForm(String nameLocation, List<dynamic> locationList) {
    // Loại bỏ khoảng trắng khỏi nameLocation
    var cleanedNameLocation = nameLocation.replaceAll(" ", "");
    if (cleanedNameLocation.isEmpty) {
      return "Không được để trống";
    } else {
      // Duyệt qua từng Map trong danh sách
      for (var map in locationList) {
        // Kiểm tra xem Map có key "id" không
        if (map.containsKey("id")) {
          var mapValue = map["id"].toString();
          // Loại bỏ khoảng trắng khỏi giá trị trong Map
          var cleanedMapValue = mapValue.replaceAll(" ", "");
          // So sánh cleanedNameLocation và cleanedMapValue
          if (cleanedMapValue == cleanedNameLocation) {
            return "Vị trí đã tồn tại";
          }
        }
      }
      return;
    }
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
  } else if (value.startsWith('-')) {
    return 'Không thể là số âm';
  }
  return null;
}

//không cho nhập quá số lượng chuyển đổi từ sỉ
String? nonBeyondSi(String? value, int amountSi) {
  if (value == null || value.isEmpty) {
    return 'Vui lòng nhập số khác 0';
  } else if (value.startsWith('0')) {
    return 'Số đầu tiên không thể là 0';
  } else if (int.tryParse(value)! > amountSi) {
    return 'Số lượng chuyển đổi > số lượng của vị trí';
  }
  return null;
}

//không cho nhập số 0 hoặc 1 hoặc rỗng
String? nonZeroOrOneInput(String? value) {
  if (value == null || value.isEmpty) {
    return 'Vui lòng nhập số khác 0';
  } else if (value.startsWith('0') || value == '1') {
    return 'Không thể chỉ nhập giá trị 1 hoặc 0';
  }
  return null;
}
