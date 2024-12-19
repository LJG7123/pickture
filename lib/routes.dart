import 'package:go_router/go_router.dart';
import 'package:pickture/screens/auth/sign_in/sign_in_screen.dart';
import 'package:pickture/screens/auth/sign_up/sign_up_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
  ],
);
