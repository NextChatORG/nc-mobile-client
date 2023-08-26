import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nc_mobile_client/src/features/authentication/presentation/auth_view.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool rememberAccount = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AuthView(
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
            child: TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                fillColor: theme.colorScheme.shadow,
                filled: true,
                labelText: 'Username',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 24),
            child: TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                fillColor: theme.colorScheme.shadow,
                filled: true,
                labelText: 'Password',
              ),
              obscureText: true,
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: rememberAccount,
                onChanged: (value) {
                  setState(() {
                    rememberAccount = value!;
                  });
                },
              ),
              const Text('Remember'),
            ],
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
                  onPressed: () {},
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
    );
  }
}
