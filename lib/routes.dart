import 'package:go_router/go_router.dart';
import 'package:pickture/screens/auth/sign_in/sign_in_screen.dart';
import 'package:pickture/screens/auth/sign_up/sign_up_screen.dart';
import 'package:pickture/screens/auth/sign_up/sign_up_with_google_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SignInScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/signup_with_google',
      builder: (context, state) => SignUpWithGoogleScreen(),
    ),
  ],
);
