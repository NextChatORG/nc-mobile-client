import 'package:go_router/go_router.dart';
import 'package:nc_mobile_client/src/features/authentication/presentation/sign_in_screen.dart';
import 'package:nc_mobile_client/src/features/authentication/presentation/sign_up_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        redirect: (context, state) {
          return '/signIn';
        },
    ),
    GoRoute(path: '/signIn', builder: (context, state) => const SignInScreen()),
    GoRoute(path: '/signUp', builder: (context, state) => const SignUpScreen()),
  ],
);
