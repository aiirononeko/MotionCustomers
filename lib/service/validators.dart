class Validator {

  static String? emailValidate(String value) {
    return RegExp(r"^[0-9a-z_./?-]+@([0-9a-z-]+\.)+[0-9a-z-]+$").hasMatch(value)
        ? null : '正しいメールアドレスを入力してください';
  }

  static String? passwordValidate(String value) {
    return RegExp(r"^[a-zA-Z0-9]{6,}$").hasMatch(value)
        ? null : "6文字以上の英数字を入力してください";
  }

  static String? confirmPasswordValidate(String password, String confirmPassword) {
    return password == confirmPassword ? null : "正しいパスワードを入力してください";
  }
}
