import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nc_mobile_client/src/features/authentication/application/auth_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    var navigator = GoRouter.of(context);

    return Scaffold(
      body: Column(
        children: [
          const Text('Home screen!!'),
          Container(
            margin: const EdgeInsets.only(top: 36),
            child: FilledButton(
              onPressed: () async {
                await authProvider.logOut();
                await navigator.pushReplacement('/');
              },
              child: const Row(
                children: [
                  Text('Log Out'),
                  Icon(Icons.keyboard_arrow_right),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
