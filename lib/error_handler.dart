import 'package:firebase_auth/firebase_auth.dart';

class ErrorMessages {
  static const String channelError = '이메일 또는 비밀번호가 비어있습니다.';
  static const String invalidCredential = '이메일 또는 비밀번호를 확인해 주세요.';
  static const String invalidEmail = '유효하지 않은 이메일 주소입니다.';
  static const String unknownError = '알 수 없는 오류가 발생했습니다.';
}

class FirebaseErrorHandler {
  static String handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
        return ErrorMessages.invalidCredential;
      case 'invalid-email':
        return ErrorMessages.invalidEmail;
      case 'channel-error':
        return ErrorMessages.channelError;
      default:
        return ErrorMessages.unknownError;
    }
  }
}
