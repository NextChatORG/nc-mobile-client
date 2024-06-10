import 'package:go_router/go_router.dart';
import 'package:nc_mobile_client/src/features/authentication/application/auth_provider.dart';
import 'package:nc_mobile_client/src/features/authentication/presentation/recovery_codes_screen.dart';
import 'package:nc_mobile_client/src/features/authentication/presentation/sign_in_screen.dart';
import 'package:nc_mobile_client/src/features/authentication/presentation/sign_up_screen.dart';
import 'package:nc_mobile_client/src/features/home/presentation/home_screen.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        redirect: (context, state) async {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await authProvider.loadDataFromDB();

          return authProvider.isLogged ? '/home' : '/signIn';
        },
    ),
    // Auth
    GoRoute(path: '/signIn', builder: (context, state) => const SignInScreen()),
    GoRoute(path: '/signUp', builder: (context, state) => const SignUpScreen()),
    GoRoute(path: '/recoveryCodes', builder: (context, state) => const RecoveryCodesScreen()),
    // General
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
  ],
);
