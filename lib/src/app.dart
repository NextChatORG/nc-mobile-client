import 'package:flutter/material.dart';
import 'package:nc_mobile_client/src/routing/router.dart';

class NextChatApp extends StatelessWidget {
  const NextChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'NextChat',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF673AB7),
          onPrimary: Color(0xFFFFFFFF),
          secondary: Color(0xFF89B73A),
          shadow: Color(0xFF131316),
          surface: Color(0xFF2F3037),
        ),
        fontFamily: 'Noto Sans',
        useMaterial3: true,
      ),
    );
  }
}
