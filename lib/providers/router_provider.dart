import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/models/like.dart';
import 'package:pickture/providers/auth_provider.dart';
import 'package:pickture/screens/auth/sign_in/sign_in_screen.dart';
import 'package:pickture/screens/auth/sign_up/sign_up_screen.dart';
import 'package:pickture/screens/auth/sign_up/sign_up_with_google_screen.dart';
import 'package:pickture/screens/chat/chat_list_screen.dart';
import 'package:pickture/screens/chat/chat_room_screen.dart';
import 'package:pickture/screens/chat/new_chat_screen.dart';
import 'package:pickture/screens/chat/new_group_chat_screen.dart';
import 'package:pickture/screens/post/like_screen.dart';
import 'package:pickture/screens/post/post_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/signup_with_google',
        builder: (context, state) => const SignUpWithGoogleScreen(),
      ),
      GoRoute(
        path: '/chats',
        builder: (context, state) => const ChatListScreen(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const NewChatScreen(),
            routes: [
              GoRoute(
                path: 'group',
                builder: (context, state) => const NewGroupChatScreen(),
              ),
            ],
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) => ChatRoomScreen(
              chatId: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: "/",
        builder: (context, state) => const PostScreen(),
      ),
      GoRoute(
        path: "/like",
        builder: (context, state) {
          final likes = state.extra as List<Like>;
          return LikeScreen(likes: likes);
        },
      ),
    ],
    redirect: (context, state) {
      if (authState.value != null && (state.matchedLocation == '/signin' || state.matchedLocation == '/signup')) {
        return '/';
      }
      if (authState.value == null && (state.matchedLocation != '/signin' && state.matchedLocation != '/signup')) {
        return '/signin';
      }
      return null;
    },
  );

  ref.listen(authStateProvider, (previous, next) {
    router.refresh();
  });

  return router;
});