import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:nc_mobile_client/src/features/authentication/application/auth_provider.dart';
import 'package:nc_mobile_client/src/features/authentication/presentation/auth_view.dart';
import 'package:provider/provider.dart';

class RecoveryCodesScreen extends StatefulWidget {
  const RecoveryCodesScreen({super.key});

  @override
  RecoveryCodesScreenState createState() => RecoveryCodesScreenState();
}

class RecoveryCodesScreenState extends State<RecoveryCodesScreen> {
  Future<void> onCopy(AuthProvider authProvider) async {
    await Clipboard.setData(ClipboardData(text: authProvider.recoveryCodes.join("      ")));
  }

  void onNext(AuthProvider authProvider, GoRouter navigator, ScaffoldMessengerState messenger) {
    if (!authProvider.isLogged) {
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
    }

    navigator.pushReplacement('/');
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var navigator = GoRouter.of(context);
    var mediaQuery = MediaQuery.of(context);
    var messenger = ScaffoldMessenger.of(context);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    return AuthView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recovery codes',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.start,
          ),
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 24),
            child: const Text(
              'Save this codes for recover your account in the future',
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          for (final String recoveryCode in authProvider.recoveryCodes)
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                color: theme.hoverColor,
              ),
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(vertical: 12),
              width: mediaQuery.size.width - 24,
              child: Text(
                recoveryCode,
                textAlign: TextAlign.center,
              ),
            ),
          Container(
            margin: const EdgeInsets.only(top: 36),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async => await onCopy(authProvider),
                  style: TextButton.styleFrom(foregroundColor: theme.colorScheme.secondary),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: const Icon(Icons.content_copy),
                      ),
                      const Text('Copy codes'),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: () => onNext(authProvider, navigator, messenger),
                  child: const Row(
                    children: [
                      Text('Next'),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
