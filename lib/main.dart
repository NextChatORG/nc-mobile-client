import 'package:flutter/material.dart';
import 'package:nc_mobile_client/src/app.dart';
import 'package:nc_mobile_client/src/features/authentication/application/auth_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(
  providers: [
    Provider(create: (context) => AuthProvider()),
  ],
  child: const NextChatApp(),
));
