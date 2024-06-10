import 'package:nc_mobile_client/src/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class AuthProvider {
  String _accessToken = '';
  String _refreshToken = '';

  List<String> _recoveryCodes = [];

  bool get isLogged => _accessToken.isNotEmpty && _refreshToken.isNotEmpty;

  List<String> get recoveryCodes => _recoveryCodes;

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
