import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:nc_mobile_client/src/constants/application_settings.dart';
import 'package:nc_mobile_client/src/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class AuthProvider {
  String _accessToken = '';
  String _refreshToken = '';

  List<String> _recoveryCodes = [];

  bool get isLogged => _accessToken.isNotEmpty && _refreshToken.isNotEmpty;

  List<String> get recoveryCodes => _recoveryCodes;

  Future<void> refreshTokenIfNecessary() async {
    if (_accessToken.isEmpty || _refreshToken.isEmpty) return;

    final accessTokenData = JWT.decode(_accessToken).payload;
    final refreshTokenData = JWT.decode(_refreshToken).payload;

    final accessTokenExp = DateTime.fromMillisecondsSinceEpoch(accessTokenData['exp'] * 1000);
    final accessTokenExpired = DateTime.now().isAfter(accessTokenExp);

    final refreshTokenExp = DateTime.fromMillisecondsSinceEpoch(refreshTokenData['exp'] * 1000);
    final refreshTokenExpired = DateTime.now().isAfter(refreshTokenExp);

    if (accessTokenData['sub'] != refreshTokenData['sub'] || refreshTokenExpired) {
      await logOut();
      return;
    }

    if (!accessTokenExpired) return;

    var url = Uri.parse("${ApplicationSettings.baseAPIUrl}/auth/refreshToken");

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': _refreshToken}),
      );

      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _accessToken = data['access_token'] as String;

        final database = await DatabaseHelper.instance.database;

        await database.insert(
          DatabaseHelper.authInfoTable,
          {
            'key_name': 'access_token',
            'value': _accessToken,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        return;
      }
    } on Exception catch (e) {
      print(e);
    }

    await logOut();
  }

  Future<void> loadDataFromDB() async {
    final database = await DatabaseHelper.instance.database;

    List<Map<String, dynamic>> authInfo = await database.query(DatabaseHelper.authInfoTable);
    if (authInfo.isNotEmpty) {
      for (var row in authInfo) {
        final keyName = row['key_name'] as String;
        final value = row['value'] as String;

        if (keyName == 'access_token') {
          _accessToken = value;
        } else if (keyName == 'refresh_token') {
          _refreshToken = value;
        }
      }

      await refreshTokenIfNecessary();
    }
  }

  Future<void> _saveToDB() async {
    final database = await DatabaseHelper.instance.database;

    await database.insert(
      DatabaseHelper.authInfoTable,
      {
        'key_name': 'access_token',
        'value': _accessToken,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await database.insert(
      DatabaseHelper.authInfoTable,
      {
        'key_name': 'refresh_token',
        'value': _refreshToken,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> saveDataFromLogIn(Map<String, dynamic> data) async {
    _accessToken = data['access_token'] as String;
    _refreshToken = data['refresh_token'] as String;

    await _saveToDB();
  }

  Future<void> saveDataFromSignUp(Map<String, dynamic> data) async {
    _accessToken = data['access_token'] as String;
    _refreshToken = data['refresh_token'] as String;

    _recoveryCodes = (data['recovery_codes'] as List).map((e) => e as String).toList();

    await _saveToDB();
  }

  void saveDataFromRecoverAccount(List<String> recoveryCodes) {
    _recoveryCodes = recoveryCodes;
  }

  Future<void> logOut() async {
    final database = await DatabaseHelper.instance.database;
    final deletedCount = await database.delete(
      DatabaseHelper.authInfoTable,
      where: 'key_name = ? OR key_name = ?',
      whereArgs: ['access_token', 'refresh_token'],
    );

    if (deletedCount == 2) {
      _accessToken = '';
      _refreshToken = '';
      _recoveryCodes = [];
    }
  }
}
