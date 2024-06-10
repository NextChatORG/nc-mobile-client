import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nc_mobile_client/src/constants/application_settings.dart';
import 'package:nc_mobile_client/src/features/authentication/application/auth_provider.dart';
import 'package:nc_mobile_client/src/features/authentication/data/auth_repository.dart';
import 'package:nc_mobile_client/src/features/authentication/domain/auth_exceptions.dart';
import 'package:nc_mobile_client/src/features/authentication/presentation/auth_view.dart';
import 'package:provider/provider.dart';

class RecoveryCodesScreen extends StatefulWidget {
  const RecoveryCodesScreen({super.key});

  @override
  RecoveryCodesScreenState createState() => RecoveryCodesScreenState();
}

class RecoveryCodesScreenState extends State<RecoveryCodesScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    var authProvider = Provider.of<AuthProvider>(context);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 36),
                child: FilledButton(
                  onPressed: () => context.pushReplacement('/'),
                  child: const Row(
                    children: [
                      Text('Next'),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
