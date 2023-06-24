class SignUpWithEmaiAndPasswordFailure {
  final String message;

  const SignUpWithEmaiAndPasswordFailure([this.message = "Có lỗi xảy ra !!"]);

  factory SignUpWithEmaiAndPasswordFailure.code(String code) {
    switch (code) {
      case "email-already-in-use":
        return const SignUpWithEmaiAndPasswordFailure("Email đã tồn tại");

      case "invalid-email":
        return const SignUpWithEmaiAndPasswordFailure(
            "Email không đúng định dạng");

      case "operation-not-allowed":
        return const SignUpWithEmaiAndPasswordFailure(
            "Toán tử không cho phép. Vui lòng liên hệ hỗ trợ");

      case "weak_password":
        return const SignUpWithEmaiAndPasswordFailure("Nhập mật khẩu mạnh hơn");

      default:
        return const SignUpWithEmaiAndPasswordFailure();
    }
  }
}
