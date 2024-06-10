import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:nc_mobile_client/src/constants/application_settings.dart';
import 'package:nc_mobile_client/src/features/authentication/domain/auth_exceptions.dart';

class AuthRepository {
  static Future<Map<String, dynamic>?> logIn(String username, String password) async {
    var url = Uri.parse("${ApplicationSettings.baseAPIUrl}/auth/logIn");

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 400) {
        throw GeneralFormException(data['message']);
      } else if (response.statusCode == 200) {
        return data;
      }
    } on SocketException catch (e) {
      if (e.message == 'Connection refused') {
        throw const GeneralFormException('Cannot connect to the server');
      }

      print(e.message);
    }

    return null;
  }

  static Future<Map<String, dynamic>?> signUp(String username, String password, String confirmPassword) async {
    var url = Uri.parse("${ApplicationSettings.baseAPIUrl}/auth/signUp");

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'confirm_password': confirmPassword,
          'terms': true,
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 400 || response.statusCode == 409) {
        throw GeneralFormException(data['message']);
      } else if (response.statusCode == 200) {
        return data;
      }
    } on SocketException catch (e) {
      if (e.message == 'Connection refused') {
        throw const GeneralFormException('Cannot connect to the server');
      }
      print(e.message);
    }

    return null;
  }
}
