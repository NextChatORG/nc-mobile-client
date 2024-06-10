import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nc_mobile_client/src/features/authentication/application/auth_provider.dart';
import 'package:nc_mobile_client/src/features/authentication/data/auth_repository.dart';
import 'package:nc_mobile_client/src/features/authentication/domain/auth_exceptions.dart';
import 'package:nc_mobile_client/src/features/authentication/presentation/auth_view.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  Future<void> onSubmit(
      AuthProvider authProvider,
      GoRouter navigator,
      ScaffoldMessengerState messenger,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final responseData = await AuthRepository.logIn(
        _usernameController.text,
        _passwordController.text,
      );

      if (responseData != null) {
        await authProvider.saveDataFromLogIn(responseData);
        navigator.pushReplacement('/');
      }
    } on GeneralFormException catch (e) {
      messenger.showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          e.message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var navigator = GoRouter.of(context);
    var messenger = ScaffoldMessenger.of(context);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    return AuthView(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Please log in to your account',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 48),
              child: TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  fillColor: theme.colorScheme.shadow,
                  filled: true,
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }

                  return null;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 36, top: 24),
              child: TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  fillColor: theme.colorScheme.shadow,
                  filled: true,
                  labelText: 'Password',
                ),
                obscureText: true,
                onFieldSubmitted: (value) async => await onSubmit(authProvider, navigator, messenger),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }

                  return null;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () => context.go('/recoverAccount'),
                    style: TextButton.styleFrom(foregroundColor: theme.colorScheme.secondary),
                    child: const Text('Forgot password?'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: FilledButton(
                    onPressed: () async => await onSubmit(authProvider, navigator, messenger),
                    child: const Row(
                      children: [
                        Text('Log in'),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 24),
                child: TextButton(
                  onPressed: () => context.go('/signUp'),
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: RichText(
                    text: TextSpan(
                      text: "Don't you have an account? ",
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            color: theme.colorScheme.secondary,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
