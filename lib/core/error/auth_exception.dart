import 'package:firebase_auth/firebase_auth.dart';
import 'package:pickture/core/error/app_exception.dart';

AppException handleAuthException(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-credential':
      return AppException(AuthExceptionMessages.invalidCredential,
          code: e.code);
    case 'invalid-email':
      return AppException(AuthExceptionMessages.invalidEmail, code: e.code);
    case 'channel-error':
      return AppException(AuthExceptionMessages.channelError, code: e.code);
    default:
      return AppException(AuthExceptionMessages.unknownError, code: e.code);
  }
}

class AuthExceptionMessages {
  static const String channelError = '이메일 또는 비밀번호가 비어있습니다.';
  static const String invalidCredential = '이메일 또는 비밀번호를 확인해 주세요.';
  static const String invalidEmail = '유효하지 않은 이메일 주소입니다.';
  static const String unknownError = '알 수 없는 오류가 발생했습니다.';
}
