import 'package:go_router/go_router.dart';
import 'package:pickture/models/like.dart';
import 'package:pickture/models/post.dart';
import 'package:pickture/screens/auth/sign_in/sign_in_screen.dart';
import 'package:pickture/screens/auth/sign_up/sign_up_screen.dart';
import 'package:pickture/screens/home_screen.dart';
import 'package:pickture/screens/post/like_screen.dart';
import 'package:pickture/screens/post/post_screen.dart';
import 'package:pickture/screens/post/save_screen.dart';
import 'screens/chat/chat_list_screen.dart';
import 'package:pickture/screens/auth/sign_up/sign_up_with_google_screen.dart';
import 'screens/chat/new_chat_screen.dart';
import 'screens/chat/chat_room_screen.dart';
import 'screens/chat/new_group_chat_screen.dart';

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
      path: "/post",
      builder: (context, state) => const PostScreen(),
    ),
    GoRoute(
      path: "/like",
      builder: (context, state) {
        final likes = state.extra as List<Like>;
        return LikeScreen(likes: likes);
      },
    ),
    GoRoute(
      path: "/home",
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: "/save",
      builder: (context, state) {
        final post = state.extra as Post;
        return SaveScreen(post: post);
      },
    ),
  ],
);
