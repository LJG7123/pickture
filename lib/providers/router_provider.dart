import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/models/like.dart';
import 'package:pickture/models/post.dart';
import 'package:pickture/models/user_model.dart';
import 'package:pickture/providers/auth_provider.dart';
import 'package:pickture/screens/auth/sign_in/sign_in_screen.dart';
import 'package:pickture/screens/auth/sign_up/sign_up_screen.dart';
import 'package:pickture/screens/auth/sign_up/sign_up_with_google_screen.dart';
import 'package:pickture/screens/chat/chat_list_screen.dart';
import 'package:pickture/screens/chat/chat_room_screen.dart';
import 'package:pickture/screens/chat/new_chat_screen.dart';
import 'package:pickture/screens/chat/new_group_chat_screen.dart';
import 'package:pickture/screens/edit_profile_image/edit_profile_image_screen.dart';
import 'package:pickture/screens/home_screen.dart';
import 'package:pickture/screens/post/follow_screen.dart';
import 'package:pickture/screens/post/like_screen.dart';
import 'package:pickture/screens/post/post_screen.dart';
import 'package:pickture/screens/post/save_screen.dart';
import 'package:pickture/screens/post/user_post_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/home',
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
        path: "/post",
        builder: (context, state) => const PostScreen(),
      ),
      GoRoute(
        path: "/user_post",
        builder: (context, state) {
          final user = state.extra as UserModel;
          return UserPostScreen(user: user);
        },
      ),
      GoRoute(
        path: "/like",
        builder: (context, state) {
          final likes = state.extra as List<Like>;
          return LikeScreen(likes: likes);
        },
      ),
      GoRoute(
        path: "/follow",
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final userIds = List<String>.from(extra["userIds"]);
          final isFollow = extra["isFollow"] as bool;
          return FollowScreen(userIds: userIds, isFollow: isFollow);
        },
      ),
      GoRoute(
        path: "/home",
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: "/save",
        builder: (context, state) {
          final post = state.extra as Post?;
          return SaveScreen(post: post);
        },
      ),
      GoRoute(
        path: '/edit_profile_image',
        builder: (context, state) => EditProfileImageScreen(),
      ),
    ],
    redirect: (context, state) {
      if (ref.read(authProvider).isLoading) {
        return null;
      }
      if (ref.read(authProvider).value != null &&
          (state.matchedLocation == '/signin' || state.matchedLocation == '/signup' || state.matchedLocation == '/signup_with_google')) {
        return '/home';
      }
      if (ref.read(authProvider).value == null &&
          (state.matchedLocation != '/signin' && state.matchedLocation != '/signup' && state.matchedLocation != '/signup_with_google')) {
        return '/signin';
      }
      return null;
    },
  );

  ref.listen(authProvider.select((value) => value.value), (previous, next) {
    router.refresh();
  });

  return router;
});

final routeInformationProvider = ChangeNotifierProvider((ref) {
  final router = ref.watch(routerProvider);
  return router.routeInformationProvider;
});

final currentRouteProvider = Provider((ref) {
  return ref.watch(routeInformationProvider).value.uri;
});
