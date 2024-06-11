import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nc_mobile_client/src/constants/application_settings.dart';
import 'package:nc_mobile_client/src/features/authentication/application/auth_provider.dart';
import 'package:nc_mobile_client/src/features/authentication/data/auth_repository.dart';
import 'package:nc_mobile_client/src/features/authentication/domain/auth_exceptions.dart';
import 'package:nc_mobile_client/src/features/authentication/presentation/auth_view.dart';
import 'package:provider/provider.dart';

class RecoverAccountScreen extends StatefulWidget {
  const RecoverAccountScreen({super.key});

  @override
  RecoverAccountScreenState createState() => RecoverAccountScreenState();
}

class RecoverAccountScreenState extends State<RecoverAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _recoveryCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _visiblePasswords = false;

  Future<void> onSubmit(
      AuthProvider authProvider,
      GoRouter navigator,
      ScaffoldMessengerState messenger,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      if (_passwordController.text.isEmpty && _confirmPasswordController.text.isEmpty) {
        final responseData = await AuthRepository.recoverAccount(_usernameController.text, _recoveryCodeController.text, null, null);
        if (responseData == null) return;

        setState(() {
          _visiblePasswords = true;
        });

        return;
      }

      final responseData = await AuthRepository.recoverAccount(
        _usernameController.text,
        _recoveryCodeController.text,
        _passwordController.text,
        _confirmPasswordController.text,
      );

      if (responseData == null) return;

      FocusManager.instance.primaryFocus?.unfocus();

      final recoveryCodes = (responseData['recovery_codes'] as List).map((e) => e as String).toList();
      if (recoveryCodes.isEmpty) {
        messenger.showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Please log in using your new password!',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ));

        navigator.pushReplacement('/');

        return;
      }

      messenger.showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'Please save your new recovery codes!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ));

      authProvider.saveDataFromRecoverAccount(recoveryCodes);
      navigator.pushReplacement('/recoveryCodes');
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
      title: 'Recover account',
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'Use one of your account recovery codes to set a new password',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.left,
                ),
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
                readOnly: _visiblePasswords,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }

                  return null;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 24),
              child: TextFormField(
                controller: _recoveryCodeController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  fillColor: theme.colorScheme.shadow,
                  filled: true,
                  labelText: 'Recovery code',
                ),
                obscureText: true,
                readOnly: _visiblePasswords,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the recovery code';
                  }

                  return null;
                },
              ),
            ),
            if (_visiblePasswords) Container(
              margin: const EdgeInsets.only(top: 24),
              child: TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  fillColor: theme.colorScheme.shadow,
                  filled: true,
                  labelText: 'New password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the new password';
                  } else if (value.length < 8 || value.length > 40) {
                    return 'New password must have between 8 and 40 characters';
                  } else if (!ApplicationSettings.passwordRegexp.hasMatch(value)) {
                    return 'New password cannot contains whitespaces';
                  }

                  return null;
                },
              ),
            ),
            if (_visiblePasswords) Container(
              margin: const EdgeInsets.only(top: 24),
              child: TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  fillColor: theme.colorScheme.shadow,
                  filled: true,
                  labelText: 'Confirm new password',
                ),
                obscureText: true,
                onFieldSubmitted: (value) async => await onSubmit(authProvider, navigator, messenger),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm the new password';
                  } else if (value != _passwordController.text) {
                    return 'The passwords are not equal';
                  }

                  return null;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: FilledButton(
                    onPressed: () async => await onSubmit(authProvider, navigator, messenger),
                    child: Row(
                      children: [
                        Text(_visiblePasswords ? 'Recover' : 'Next'),
                        const Icon(Icons.keyboard_arrow_right),
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
