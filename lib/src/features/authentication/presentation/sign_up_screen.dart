import 'package:flutter/material.dart';
import 'package:nc_mobile_client/src/features/authentication/presentation/auth_view.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    var insetBottom = mediaQuery.viewInsets.bottom;
    var keyboardOn = insetBottom > 0;

    return AuthView(
      showBackButton: true,
      title: 'Sign up',
      child: Column(
        children: [
          Expanded(
            flex: keyboardOn ? 1 : 2,
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                'Enjoy a new communication world!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
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
          Container(
            margin: const EdgeInsets.only(top: 24),
            child: TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                fillColor: theme.colorScheme.shadow,
                filled: true,
                labelText: 'Confirm password',
              ),
              obscureText: true,
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
                labelText: 'Beta code',
              ),
              obscureText: true,
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: acceptTerms,
                onChanged: (value) {
                  setState(() {
                    acceptTerms = value!;
                  });
                },
              ),
              const Text('Accept Terms and Conditions'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 24),
                child: FilledButton(
                  onPressed: () {},
                  child: const Row(
                    children: [
                      Text('Sign up'),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (!keyboardOn) const Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }
}
