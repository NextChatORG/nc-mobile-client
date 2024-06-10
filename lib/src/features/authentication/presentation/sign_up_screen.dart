import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nc_mobile_client/src/constants/application_settings.dart';
import 'package:nc_mobile_client/src/features/authentication/application/auth_provider.dart';
import 'package:nc_mobile_client/src/features/authentication/data/auth_repository.dart';
import 'package:nc_mobile_client/src/features/authentication/domain/auth_exceptions.dart';
import 'package:nc_mobile_client/src/features/authentication/presentation/auth_view.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool acceptTerms = false;

  Future<void> onSubmit(
      AuthProvider authProvider,
      GoRouter navigator,
      ScaffoldMessengerState messenger,
  ) async {
    if (!_formKey.currentState!.validate() || !acceptTerms) return;

    try {
      final responseData = await AuthRepository.signUp(
        _usernameController.text,
        _passwordController.text,
        _confirmPasswordController.text,
      );

      if (responseData != null) {
        await authProvider.saveDataFromSignUp(responseData);
        navigator.pushReplacement('/recoveryCodes');
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
    var mediaQuery = MediaQuery.of(context);
    var messenger = ScaffoldMessenger.of(context);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    var insetBottom = mediaQuery.viewInsets.bottom;
    var keyboardOn = insetBottom > 0;

    return AuthView(
      showBackButton: true,
      title: 'Sign up',
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
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
              child: TextFormField(
                autofocus: true,
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
                    return 'Please enter an username';
                  } else if (value.length < 4 || value.length > 20) {
                    return 'Username must have between 4 and 20 characters';
                  } else if (!ApplicationSettings.usernameRegexp.hasMatch(value)) {
                    return 'Username is not valid';
                  }

                  return null;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 24),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  } else if (value.length < 8 || value.length > 40) {
                    return 'Password must have between 8 and 40 characters';
                  } else if (!ApplicationSettings.passwordRegexp.hasMatch(value)) {
                    return 'Password cannot contains whitespaces';
                  }

                  return null;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 24),
              child: TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  fillColor: theme.colorScheme.shadow,
                  filled: true,
                  labelText: 'Confirm password',
                ),
                obscureText: true,
                onFieldSubmitted: (value) async => await onSubmit(authProvider, navigator, messenger),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm the password';
                  } else if (value != _passwordController.text) {
                    return 'The passwords are not equal';
                  }

                  return null;
                },
              ),
            ),
            FormField<bool>(
              builder: (state) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: acceptTerms,
                        onChanged: (value) => setState(() {
                          acceptTerms = value ?? false;
                        }),
                      ),
                      const Text('Accept Terms and Conditions'),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 12),
                    child: state.hasError ? Text(
                      state.errorText ?? '',
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ) : null,
                  ),
                ],
              ),
              initialValue: acceptTerms,
              validator: (value) {
                if (!acceptTerms) {
                  return 'You must need to accept terms';
                }

                return null;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: FilledButton(
                    onPressed: () async => await onSubmit(authProvider, navigator, messenger),
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
      ),
    );
  }
}
