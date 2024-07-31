mixin InputValidator {
  bool isCheckTextFieldEmpty(String value) => value.isNotEmpty;

  bool isEmailValid(String value) {
    RegExp regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regExp.hasMatch(value);
  }

  bool isPasswordValid(String value) => value.length >= 8;

  bool isMobileNoValid(String value) => value.length >= 10;
}
