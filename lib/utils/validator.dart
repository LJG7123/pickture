class Validator {
  static final emailRegex = RegExp(
      r'^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$');

  static bool isEmailValid(String email) {
    return emailRegex.hasMatch(email);
  }
}
